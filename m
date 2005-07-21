From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Fix extern inline without function body
Date: Thu, 21 Jul 2005 02:01:12 +0200
Message-ID: <42DEE5C8.9010902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070407030709010605030606"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------070407030709010605030606
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Fixes a compilation error with gcc-4.0


--------------070407030709010605030606
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix extern inline without function body

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aa4d64d057c37bc29954789fd24dcb7018ca6973
tree 540da1b32872e758ad8806057412ee08759c746a
parent 250a3087bb4488fc8f4407b3b7bbb2b44565b515
author Patrick McHardy <kaber@trash.net> Thu, 21 Jul 2005 01:53:54 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 21 Jul 2005 01:53:54 +0200

 include/linux/netfilter_ipv4/ip_conntrack.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -293,7 +293,7 @@ ip_conntrack_get(const struct sk_buff *s
 }
 
 /* decrement reference count on a conntrack */
-extern inline void ip_conntrack_put(struct ip_conntrack *ct);
+extern void ip_conntrack_put(struct ip_conntrack *ct);
 
 /* call to create an explicit dependency on ip_conntrack. */
 extern void need_ip_conntrack(void);

--------------070407030709010605030606--
