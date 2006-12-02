From: Patrick McHardy <kaber@trash.net>
Subject: [NET 01/20]: Accept wildcard delimiters in in[46]_pton
Date: Sat,  2 Dec 2006 15:49:38 +0100 (MET)
Message-ID: <20061202145242.1381.98822.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NET]: Accept wildcard delimiters in in[46]_pton

Accept -1 as delimiter to abort parsing without an error at the first
unknown character. This is needed by the upcoming nf_conntrack SIP
helper, where addresses are delimited by either '\r' or '\n' characters.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0166e0457531e1e5260463477c30dd16b81ab606
tree f752c1e10f845935f865bb1670c64d70c2cd2acd
parent 5465ae68b5ec11b2820db3f9b4c6fd94f113da44
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:52 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:52 +0100

 include/linux/inet.h |    4 ++--
 net/core/utils.c     |   10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/inet.h b/include/linux/inet.h
index b7c6da7..675a7db 100644
--- a/include/linux/inet.h
+++ b/include/linux/inet.h
@@ -46,7 +46,7 @@ #ifdef __KERNEL__
 #include <linux/types.h>
 
 extern __be32 in_aton(const char *str);
-extern int in4_pton(const char *src, int srclen, u8 *dst, char delim, const char **end);
-extern int in6_pton(const char *src, int srclen, u8 *dst, char delim, const char **end);
+extern int in4_pton(const char *src, int srclen, u8 *dst, int delim, const char **end);
+extern int in6_pton(const char *src, int srclen, u8 *dst, int delim, const char **end);
 #endif
 #endif	/* _LINUX_INET_H */
diff --git a/net/core/utils.c b/net/core/utils.c
index d93fe64..6155606 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -88,7 +88,7 @@ #define IN6PTON_DELIM		0x10000000
 #define IN6PTON_NULL		0x20000000	/* first/tail */
 #define IN6PTON_UNKNOWN		0x40000000
 
-static inline int digit2bin(char c, char delim)
+static inline int digit2bin(char c, int delim)
 {
 	if (c == delim || c == '\0')
 		return IN6PTON_DELIM;
@@ -99,7 +99,7 @@ static inline int digit2bin(char c, char
 	return IN6PTON_UNKNOWN;
 }
 
-static inline int xdigit2bin(char c, char delim)
+static inline int xdigit2bin(char c, int delim)
 {
 	if (c == delim || c == '\0')
 		return IN6PTON_DELIM;
@@ -113,12 +113,14 @@ static inline int xdigit2bin(char c, cha
 		return (IN6PTON_XDIGIT | (c - 'a' + 10));
 	if (c >= 'A' && c <= 'F')
 		return (IN6PTON_XDIGIT | (c - 'A' + 10));
+	if (delim == -1)
+		return IN6PTON_DELIM;
 	return IN6PTON_UNKNOWN;
 }
 
 int in4_pton(const char *src, int srclen,
 	     u8 *dst,
-	     char delim, const char **end)
+	     int delim, const char **end)
 {
 	const char *s;
 	u8 *d;
@@ -173,7 +175,7 @@ EXPORT_SYMBOL(in4_pton);
 
 int in6_pton(const char *src, int srclen,
 	     u8 *dst,
-	     char delim, const char **end)
+	     int delim, const char **end)
 {
 	const char *s, *tok = NULL;
 	u8 *d, *dc = NULL;
