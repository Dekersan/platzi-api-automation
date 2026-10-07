package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class TestRunner {

    private static final String REPORT_DIR = "build/karate-reports";

    @Test
    void runAll() {
        Results results = Runner.path("classpath:features")
                .tags("~@ignore", "~@known-bug")
                .reportDir(REPORT_DIR)
                .outputCucumberJson(true)
                .parallel(1);

        generateCucumberReport();
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

    private void generateCucumberReport() {
        File[] files = new File(REPORT_DIR).listFiles((dir, name) -> name.endsWith(".json"));
        if (files == null || files.length == 0) return;

        List<String> jsonFiles = Arrays.stream(files).map(File::getAbsolutePath).toList();
        Configuration config = new Configuration(new File("build"), "Platzi Fake API - QC");
        new ReportBuilder(jsonFiles, config).generateReports();
    }
}