From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH IPTABLES 2/2]: load ip_[6]tables.ko just before
 checking revision support in kernel
Date: Sat, 04 Nov 2006 02:24:18 +0900 (JST)
Message-ID: <200611031724.kA3HOK9l005062@toshiba.co.jp>
References: <200611031553.kA3FrfQI000691@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200611031553.kA3FrfQI000691@toshiba.co.jp>
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


Sorry, I sent wrong patch. This is the patch I want to send.



load ip_[6]tables.ko just before checking revision support in kernel.

---
commit e66e64ea8d10550bd4a521a263c671599dde5ec5
tree a41409625d8d95d4e5053b9627009c00bf8a5d42
parent 1d9e63a2ebb1e3ce04773653f6be4adf56dac70a
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 04 Nov 2006 02:15:53 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 04 Nov 2006 02:15:53 +0900

 include/ip6tables.h       |    1 +
 include/iptables_common.h |    1 +
 ip6tables.c               |   21 +++++++++++++++++++--
 iptables.c                |   21 +++++++++++++++++++--
 4 files changed, 40 insertions(+), 4 deletions(-)

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
index 92e434c..8bb7661 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -193,6 +193,9 @@ const char *program_version;
 const char *program_name;
 char *lib_dir;
 
+/* the path to command to load kernel module */
+const char *modprobe = NULL;
+
 /* Keeping track of external matches and targets: linked lists.  */
 struct ip6tables_match *ip6tables_matches = NULL;
 struct ip6tables_target *ip6tables_targets = NULL;
@@ -1118,6 +1121,8 @@ static int compatible_revision(const cha
 	strcpy(rev.name, name);
 	rev.revision = revision;
 
+	load_ip6tables_ko(modprobe);
+
 	max_rev = getsockopt(sockfd, IPPROTO_IPV6, opt, &rev, &s);
 	if (max_rev < 0) {
 		/* Definitely don't support this? */
@@ -1777,6 +1782,19 @@ int ip6tables_insmod(const char *modname
 	return -1;
 }
 
+int load_ip6tables_ko(const char *modprobe)
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
@@ -1855,7 +1873,6 @@ int do_command6(int argc, char *argv[], 
 	struct ip6tables_target *t;
 	const char *jumpto = "";
 	char *protocol = NULL;
-	const char *modprobe = NULL;
 	int proto_used = 0;
 
 	memset(&fw, 0, sizeof(fw));
@@ -2333,7 +2350,7 @@ int do_command6(int argc, char *argv[], 
 		*handle = ip6tc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && ip6tables_insmod("ip6_tables", modprobe) != -1)
+	if (!*handle && load_ip6tables_ko(modprobe) != -1)
 		*handle = ip6tc_init(*table);
 
 	if (!*handle)
diff --git a/iptables.c b/iptables.c
index bece359..b627d3a 100644
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
+	static int loaded = 0;
+	static int ret = -1;
+
+	if (!loaded) {
+		ret = iptables_insmod("ip_tables", NULL);
+		loaded = 1;
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
