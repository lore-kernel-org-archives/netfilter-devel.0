From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] Add support unified match/target files to iptables
Date: Tue, 9 Jun 2009 15:12:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906091505160.23699@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:40438 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbZFINMj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:12:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id D647A1F41D8
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2009 15:12:40 +0200 (CEST)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FaKLUxVfzPsU for <netfilter-devel@vger.kernel.org>;
	Tue,  9 Jun 2009 15:12:40 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id B5F021F41CD
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2009 15:12:40 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The patch below adds supporting unified match/target files - and the 
possibility to lowercase all target files - to iptables. There are a 
couple of match/target pairs (say mark/MARK), which could be covered in a 
single file, but the current search logic prevents it. The patch modifies 
the searching with adding an extra check with lowercased filename for 
targets. Comments are welcomed!

diff --git a/xtables.c b/xtables.c
index e018331..ebd0b87 100644
--- a/xtables.c
+++ b/xtables.c
@@ -16,6 +16,7 @@
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <netdb.h>
@@ -475,51 +476,74 @@ void xtables_parse_interface(const char *arg, char *vianame,
 }
 
 #ifndef NO_SHARED_LIBS
+static void *try_dlopen(const char *path, const char *extname, bool is_target)
+{
+	struct stat sb;
+	void *ptr = NULL;
+
+	if (stat(path, &sb) != 0)
+		return ptr;
+	
+	if (dlopen(path, RTLD_NOW) != NULL) {
+		/* Found library.  If it didn't register itself,
+		   maybe they specified target as match. */
+		if (is_target)
+			ptr = xtables_find_target(extname, XTF_DONT_LOAD);
+		else
+			ptr = xtables_find_match(extname, XTF_DONT_LOAD, NULL);
+	} else
+		fprintf(stderr, "%s: %s\n", path, dlerror());
+	
+	return ptr;
+}
+
+static void *try_load(unsigned int fmtlen, const char *dir,
+	const char *prefix, const char *filename, const char *extname,
+	bool is_target)
+{
+	char path[256];
+	void *ptr = NULL;
+
+	snprintf(path, sizeof(path), "%.*s/libxt_%s.so",
+	         fmtlen, dir, filename);
+	if ((ptr = try_dlopen(path, extname, is_target)) != NULL)
+		return ptr;
+
+	snprintf(path, sizeof(path), "%.*s/%s%s.so",
+	         fmtlen, dir, prefix, filename);
+	
+	return try_dlopen(path, extname, is_target);
+}
+
 static void *load_extension(const char *search_path, const char *prefix,
     const char *name, bool is_target)
 {
 	const char *dir = search_path, *next;
 	void *ptr = NULL;
-	struct stat sb;
-	char path[256];
+	char lcname[XT_FUNCTION_MAXNAMELEN-1];
+	unsigned int fmtlen;
+	int i;
+
+	if (is_target)
+		for (i = 0; name[i] && i < XT_FUNCTION_MAXNAMELEN - 1; i++)
+			lcname[i] = tolower(name[i]);
 
 	do {
 		next = strchr(dir, ':');
 		if (next == NULL)
 			next = dir + strlen(dir);
-		snprintf(path, sizeof(path), "%.*s/libxt_%s.so",
-		         (unsigned int)(next - dir), dir, name);
-
-		if (dlopen(path, RTLD_NOW) != NULL) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified target as match. */
-			if (is_target)
-				ptr = xtables_find_target(name, XTF_DONT_LOAD);
-			else
-				ptr = xtables_find_match(name,
-				      XTF_DONT_LOAD, NULL);
-		} else if (stat(path, &sb) == 0) {
-			fprintf(stderr, "%s: %s\n", path, dlerror());
-		}
 
+		fmtlen = (unsigned int)(next - dir);
+		ptr = try_load(fmtlen, dir, prefix, name, name, is_target);
 		if (ptr != NULL)
 			return ptr;
 
-		snprintf(path, sizeof(path), "%.*s/%s%s.so",
-		         (unsigned int)(next - dir), dir, prefix, name);
-		if (dlopen(path, RTLD_NOW) != NULL) {
-			if (is_target)
-				ptr = xtables_find_target(name, XTF_DONT_LOAD);
-			else
-				ptr = xtables_find_match(name,
-				      XTF_DONT_LOAD, NULL);
-		} else if (stat(path, &sb) == 0) {
-			fprintf(stderr, "%s: %s\n", path, dlerror());
+		if (is_target) {
+			ptr = try_load(fmtlen, dir, prefix, lcname, name, is_target);
+			if (ptr != NULL)
+		    		return ptr;
 		}
 
-		if (ptr != NULL)
-			return ptr;
-
 		dir = next + 1;
 	} while (*next != '\0');
 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
