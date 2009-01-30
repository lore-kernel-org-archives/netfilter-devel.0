From: jamal <hadi@cyberus.ca>
Subject: Re: libxtables: prefix names and order it #1
Date: Fri, 30 Jan 2009 08:39:49 -0500
Message-ID: <1233322789.25980.7.camel@dogo.mojatatu.com>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>
	 <1233065970.13279.74.camel@dogo.mojatatu.com>
	 <1233066572.13279.76.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0901300550390.23947@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-VwOPoykqpmrvVJTm02sL"
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:49740 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZA3Nld (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:41:33 -0500
Received: by ewy14 with SMTP id 14so779349ewy.13
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2009 05:41:30 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0901300550390.23947@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-VwOPoykqpmrvVJTm02sL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-01-30 at 05:52 +0100, Jan Engelhardt wrote:

> The proposed changes are at
> 
> 	git://dev.medozas.de/iptables master
> 
> 	92 files changed, 1063 insertions(+), 1135 deletions(-)
> 
> They are pretty broad, but repetitive.
> 

Thanks for the effort. Unfortunately i am stuck on something else i
started on for a few more days. I will jump on this when i am done.

> There are a few functions left. Like exit_error, which still has ties
> to the origin program (iptables, ip6tables), to do option freeing for
> example. Have not yet thought of how to resolve that. Ideas welcome.

I think it makes sense to make those type functions re-entrant/
independent of origin_program or original_opts and just have the app
like ipt/iptables pass them. 
As an example, here's is what i started doing with original_opts the
last time i started to move things before your changes..

cheers,
jamal

--=-VwOPoykqpmrvVJTm02sL
Content-Disposition: attachment; filename=fix-ipt-freeopts
Content-Type: text/x-patch; name=fix-ipt-freeopts; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/include/xtables/internal.h b/include/xtables/internal.h
index 24a5078..f04b3e2 100644
--- a/include/xtables/internal.h
+++ b/include/xtables/internal.h
@@ -45,6 +45,7 @@ extern char *lib_dir;
 
 extern void *fw_calloc(size_t count, size_t size);
 extern void *fw_malloc(size_t size);
+extern void free_opts(int reset_offset,  struct option *original_opts);
 
 extern const char *modprobe_program;
 extern int xtables_insmod(const char *modname, const char *modprobe, int quiet);
@@ -52,7 +53,8 @@ extern int load_xtables_ko(const char *modprobe, int quiet);
 
 /* This is decleared in ip[6]tables.c */
 extern struct afinfo afinfo;
-
+extern struct option *opts;
+extern unsigned int global_option_offset;
 /* Keeping track of external matches and targets: linked lists.  */
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
diff --git a/ip6tables.c b/ip6tables.c
index 3c45c07..1866732 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -142,8 +142,8 @@ static struct option original_opts[] = {
  * magic number of -1 */
 int line = -1;
 
-static struct option *opts = original_opts;
-static unsigned int global_option_offset = 0;
+struct option *opts = original_opts;
+unsigned int global_option_offset = 0;
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -252,16 +252,6 @@ proto_to_name(u_int8_t proto, int nolookup)
 	return NULL;
 }
 
-static void free_opts(int reset_offset)
-{
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		if (reset_offset)
-			global_option_offset = 0;
-	}
-}
-
 static void
 exit_tryhelp(int status)
 {
@@ -269,7 +259,7 @@ exit_tryhelp(int status)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
-	free_opts(1);
+	free_opts(1, original_opts);
 	exit(status);
 }
 
@@ -379,7 +369,7 @@ exit_error(enum exittype status, const char *msg, ...)
 		fprintf(stderr,
 			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
 	/* On error paths, make sure that we don't leak memory */
-	free_opts(1);
+	free_opts(1, original_opts);
 	exit(status);
 }
 
@@ -614,7 +604,7 @@ merge_options(struct option *oldopts, const struct option *newopts,
 
 	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
 	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	free_opts(0); /* Release previous options merged if any */
+	free_opts(0, original_opts); /* Release any merged options */
 	for (i = 0; i < num_new; i++) {
 		merge[num_old + i] = newopts[i];
 		merge[num_old + i].val += *option_offset;
@@ -2135,7 +2125,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	for (i = 0; i < ndaddrs; i++)
 		free(&daddrs[i]);
 
-	free_opts(1);
+	free_opts(1, original_opts);
 
 	return ret;
 }
diff --git a/iptables.c b/iptables.c
index b75df87..ad21111 100644
--- a/iptables.c
+++ b/iptables.c
@@ -141,8 +141,8 @@ static struct option original_opts[] = {
  * magic number of -1 */
 int line = -1;
 
-static struct option *opts = original_opts;
-static unsigned int global_option_offset = 0;
+struct option *opts = original_opts;
+unsigned int global_option_offset = 0;
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -254,16 +254,6 @@ enum {
 	IPT_DOTTED_MASK
 };
 
-static void free_opts(int reset_offset)
-{
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		if (reset_offset)
-			global_option_offset = 0;
-	}
-}
-
 static void
 exit_tryhelp(int status)
 {
@@ -271,7 +261,7 @@ exit_tryhelp(int status)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
-	free_opts(1);
+	free_opts(1, original_opts);
 	exit(status);
 }
 
@@ -381,7 +371,7 @@ exit_error(enum exittype status, const char *msg, ...)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
 	/* On error paths, make sure that we don't leak memory */
-	free_opts(1);
+	free_opts(1, original_opts);
 	exit(status);
 }
 
@@ -609,7 +599,7 @@ merge_options(struct option *oldopts, const struct option *newopts,
 	if (merge == NULL)
 		return NULL;
 	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	free_opts(0); /* Release previous options merged if any */
+	free_opts(0, original_opts); /* Release any merged options */
 	for (i = 0; i < num_new; i++) {
 		merge[num_old + i] = newopts[i];
 		merge[num_old + i].val += *option_offset;
@@ -1421,7 +1411,7 @@ get_kernel_version(void) {
 
 	if (uname(&uts) == -1) {
 		fprintf(stderr, "Unable to retrieve kernel version.\n");
-		free_opts(1);
+		free_opts(1, original_opts);
 		exit(1);
 	}
 
@@ -2163,7 +2153,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	free(saddrs);
 	free(daddrs);
-	free_opts(1);
+	free_opts(1, original_opts);
 
 	return ret;
 }
diff --git a/xtables.c b/xtables.c
index abdd283..e4a4adb 100644
--- a/xtables.c
+++ b/xtables.c
@@ -77,6 +77,17 @@ void *fw_malloc(size_t size)
 	return p;
 }
 
+void free_opts(int reset_offset, struct option *original_opts)
+{
+	if (opts != original_opts) {
+		free(opts);
+		opts = original_opts;
+		if (reset_offset)
+			global_option_offset = 0;
+	}
+}
+
+
 static char *get_modprobe(void)
 {
 	int procfile;

--=-VwOPoykqpmrvVJTm02sL--

