From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim 4/4] implement backticks
Date: Mon, 21 Feb 2005 18:22:01 +0100
Message-ID: <20050221172201.GB32447@roonstrasse.net>
References: <20050221171719.GA32254@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XOIedfhf+7KOe/yw"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050221171719.GA32254@roonstrasse.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

expand backticks to the output of the specified command


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="04-nfsim-backticks.patch"

Mon Feb 21 17:50:22 CET 2005  max@duempel.org
  * implemented backticks
diff -rN -u nfsim-1-old/core/tui.c nfsim-1-new/core/tui.c
--- nfsim-1-old/core/tui.c	Mon Feb 21 18:05:18 2005
+++ nfsim-1-new/core/tui.c	Mon Feb 21 17:23:10 2005
@@ -25,6 +25,7 @@
 #include "expect.h"
 #include "utils.h"
 
+#include <sys/wait.h>
 #include <stdio.h>
 #include <readline/readline.h>
 #include <readline/history.h>
@@ -220,6 +221,67 @@
 	return false;
 }
 
+/**
+ * backslash-escape a binary data block into a newly allocated
+ * string
+ *
+ * @param src a pointer to the data block
+ * @param src_len the length of the data block
+ * @return NULL if out of memory, or a pointer to the allocated escaped
+ *    string, which is terminated with a '\0' character
+ */
+static char *escape(const char *src, size_t src_len) {
+	static const char hexbuf[]= "0123456789abcdef";
+	char *dest, *p;
+	size_t i;
+
+	/* src_len * 4 is always safe, it's the longest escape
+	   sequence for all characters */
+	dest = malloc(src_len * 4 + 1);
+	if (dest == NULL)
+		return NULL;
+
+	p = dest;
+
+	for (i = 0; i < src_len; i++) {
+		if (src[i] == '\n') {
+			*p++ = '\\';
+			*p++ = 'n';
+		} else if (src[i] == '\r') {
+			*p++ = '\\';
+			*p++ = 'r';
+		} else if (src[i] == '\0') {
+			*p++ = '\\';
+			*p++ = '0';
+		} else if (src[i] == '\t') {
+			*p++ = '\\';
+			*p++ = 't';
+		} else if (src[i] == '\\') {
+			*p++ = '\\';
+			*p++ = '\\';
+		} else if (src[i] & 0x80 || (src[i] & 0xe0) == 0) {
+			*p++ = '\\';
+			*p++ = 'x';
+			*p++ = hexbuf[(src[i] >> 4) & 0xf];
+			*p++ = hexbuf[src[i] & 0xf];
+		} else
+			*p++ = src[i];
+	}
+
+	*p++ = 0;
+
+	i = p - dest;
+
+	/* reallocate to save memory */
+	p = realloc(dest, i);
+	if (p == NULL) {
+		free(dest);
+		return NULL;
+	}
+
+	return p;
+}
+
 static void process_line(char *line)
 {
 	int argc, prevspace;
@@ -237,6 +299,92 @@
 		if (isspace(*line)) {
 			*line = 0;
 			prevspace = 1;
+		} else if (prevspace && *line == '`') {
+			char *end;
+			pid_t pid, pid2;
+			int ret, fds[2];
+			char *buffer = NULL, *new_buffer;
+			size_t buffer_size = 0, buffer_pos = 0;
+			ssize_t nbytes;
+
+			/* find the end delimiter */
+			end = strchr(++line, '`');
+			if (end == NULL)
+				script_fail("no matching \"`\" found");
+
+			/* fork and execute the specified program in a
+			   shell */
+			ret = pipe(fds);
+			if (ret < 0)
+				script_fail("pipe() failed: %s",
+					    strerror(errno));
+
+			pid = fork();
+			if (pid < 0) {
+				script_fail("fork() failed: %s",
+					    strerror(errno));
+			} else if (pid == 0) {
+				dup2(fds[1], 1);
+				close(fds[0]);
+				close(fds[1]);
+
+				*end = 0;
+				execl("/bin/sh", "sh", "-c", line, NULL);
+				fprintf(stderr, "failed to execute '%s': %s\n",
+					line, strerror(errno));
+				exit(1);
+			}
+
+			close(fds[1]);
+
+			/* read output from the child process */
+			while (1) {
+				/* grow the buffer if required; limit
+				   that to 1 MB for now */
+				if (buffer_pos == buffer_size &&
+				    buffer_size < 1024 * 1024) {
+					buffer_size += 4096;
+					new_buffer = realloc(buffer, buffer_size);
+					if (new_buffer == NULL)
+						script_fail("out of memory");
+					buffer = new_buffer;
+				}
+
+				/* read the next chunk */
+				nbytes = read(fds[0], buffer + buffer_pos, buffer_size - buffer_pos);
+				if (nbytes <= 0)
+					break;
+
+				buffer_pos += (size_t)nbytes;
+			}
+
+			close(fds[0]);
+
+			/* check child's exit status */
+			pid2 = waitpid(pid, &ret, 0);
+			if (pid2 != pid)
+				script_fail("waitpid() failed");
+
+			if (WIFSIGNALED(ret) != 0)
+				script_fail("child terminated by signal %d",
+					    WIFSIGNALED(ret));
+
+			if (WEXITSTATUS(ret) != 0)
+				script_fail("child exited with status %d",
+					    WEXITSTATUS(ret));
+
+			/* escape the output */
+			argv[argc] = escape(buffer, buffer_pos);
+			if (argv[argc] == NULL)
+				script_fail("out of memory");
+
+			/* XXX: the escaped buffer is never freed */
+
+			free(buffer);
+
+			argc++;
+			prevspace = 0;
+			line = end;
 		} else if (prevspace) {
 			argv[argc++] = line;
 			prevspace = 0;


--XOIedfhf+7KOe/yw--
