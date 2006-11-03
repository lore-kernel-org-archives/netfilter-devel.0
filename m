From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH IPTABLES 2/2]: load ip_[6]tables.ko just before checking
 revision support in kernel
Date: Sat, 04 Nov 2006 00:53:40 +0900 (JST)
Message-ID: <200611031553.kA3FrfQI000691@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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



---
commit 1f686ce415e381cb26adea60a336b991876e8a2c
tree 24ee804a2155844acb44959e8179e8cd62c66cc4
parent 1d9e63a2ebb1e3ce04773653f6be4adf56dac70a
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 04 Nov 2006 00:04:08 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 04 Nov 2006 00:04:08 +0900

 include/ip6tables.h       |    1 +
 include/iptables_common.h |    1 +
 ip6tables.c               |   13 +++++++++++++
 iptables.c                |   21 +++++++++++++++++++--
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 8fe7899..7907f66 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -172,5 +172,6 @@ extern int for_each_chain(int (*fn)(cons
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int ip6tables_insmod(const char *modname, const char *modprobe);
+extern int load_ip6tables_ko(const char *modprobe);
 
 #endif /*_IP6TABLES_USER_H*/
diff --git a/include/iptables_common.h b/include/iptables_common.h
index 05516ac..6f7e429 100644
--- a/include/iptables_common.h
+++ b/include/iptables_common.h
@@ -28,6 +28,7 @@ extern int string_to_number_ll(const cha
 			    unsigned long long int,
 			    unsigned long long *);
 extern int iptables_insmod(const char *modname, const char *modprobe);
+extern int load_iptables_ko(const char *modprobe);
 void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
diff --git a/ip6tables.c b/ip6tables.c
index 92e434c..d13c389 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1777,6 +1777,19 @@ int ip6tables_insmod(const char *modname
 	return -1;
 }
 
+int load_iptables_ko(const char *modprobe)
+{
+	static int loaded = 0;
+	static int ret = -1;
+
+	if (!loaded) {
+		ret = ip6tables_insmod("ip6_tables", modprobe);
+		loaded = 1;
+	}
+
+	return ret;
+}
+
 static struct ip6t_entry *
 generate_entry(const struct ip6t_entry *fw,
 	       struct ip6tables_rule_match *matches,
diff --git a/iptables.c b/iptables.c
index bece359..03ab8f6 100644
--- a/iptables.c
+++ b/iptables.c
@@ -197,6 +197,9 @@ char *lib_dir;
 
 int kernel_version;
 
+/* the path to command to load kernel module */
+const char *modprobe = NULL;
+
 /* Keeping track of external matches and targets: linked lists.  */
 struct iptables_match *iptables_matches = NULL;
 struct iptables_target *iptables_targets = NULL;
@@ -1147,6 +1150,8 @@ static int compatible_revision(const cha
 		exit(1);
 	}
 
+	load_iptables_ko(modprobe);
+
 	strcpy(rev.name, name);
 	rev.revision = revision;
 
@@ -1845,6 +1850,19 @@ int iptables_insmod(const char *modname,
 	return -1;
 }
 
+int load_iptables_ko(const char *modprobe)
+{
+	static int loaded_iptables = 0;
+	static int ret = -1;
+
+	if (!loaded_iptables) {
+		ret = iptables_insmod("ip_tables", NULL);
+		loaded_iptables = 1;
+	}
+
+	return ret;
+}
+
 static struct ipt_entry *
 generate_entry(const struct ipt_entry *fw,
 	       struct iptables_rule_match *matches,
@@ -1938,7 +1956,6 @@ int do_command(int argc, char *argv[], c
 	struct iptables_target *t;
 	const char *jumpto = "";
 	char *protocol = NULL;
-	const char *modprobe = NULL;
 	int proto_used = 0;
 
 	memset(&fw, 0, sizeof(fw));
@@ -2426,7 +2443,7 @@ int do_command(int argc, char *argv[], c
 		*handle = iptc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && iptables_insmod("ip_tables", modprobe) != -1)
+	if (!*handle && load_iptables_ko(modprobe) != -1)
 		*handle = iptc_init(*table);
 
 	if (!*handle)
