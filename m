From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Constify argument in exit_error
Date: Mon, 30 Jul 2007 16:44:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707301635020.26373@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net, yasuyuki@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Make @msg argument a const char *, just like printf().


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/xtables.h |    2 +-
 ip6tables.c       |    2 +-
 iptables-xml.c    |    2 +-
 iptables.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Index: iptables/include/xtables.h
===================================================================
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -226,7 +226,7 @@ enum exittype {
 extern void exit_printhelp() __attribute__((noreturn));
 extern void exit_tryhelp(int) __attribute__((noreturn));
 int check_inverse(const char option[], int *invert, int *optind, int argc);
-void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
+void exit_error(enum exittype, const char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
 
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -268,7 +268,7 @@ static void free_opts(int reset_offset)
 }
 
 void
-exit_error(enum exittype status, char *msg, ...)
+exit_error(enum exittype status, const char *msg, ...)
 {
 	va_list args;
 
Index: iptables/iptables-xml.c
===================================================================
--- iptables.orig/iptables-xml.c
+++ iptables/iptables-xml.c
@@ -29,7 +29,7 @@ const char *program_version;
 
 #ifndef IPTABLES_MULTI
 int line = 0;
-void exit_error(enum exittype status, char *msg, ...)
+void exit_error(enum exittype status, const char *msg, ...)
 {
 	va_list args;
 
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -348,7 +348,7 @@ static void free_opts(int reset_offset)
 }
 
 void
-exit_error(enum exittype status, char *msg, ...)
+exit_error(enum exittype status, const char *msg, ...)
 {
 	va_list args;
 
