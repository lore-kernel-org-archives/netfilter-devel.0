From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/4]: Remove two unused files
Date: Mon, 15 Aug 2005 00:43:42 +0200
Message-ID: <42FFC91E.9090806@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070406080605020101010008"
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
--------------070406080605020101010008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following a three minor patches and one patch to finally
remove the broken cmd/sid and pid matching from ipt_owner.
Users probably won't be happy, but I don't see a chance for
fixing it and apparently it is beginning to stand in the
way of other changes.


--------------070406080605020101010008
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Remove two unused files

Signed-off-by: Domen Puncer <domen@coderock.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5f234544ded29913154a728719cfcf3cbceb9667
tree ac39f1714316ccc01b102136ee04fa283569331b
parent 15384b6699ac1c8753fa6829e35e74d57e0aa7e0
author Domen Puncer <domen@coderock.org> Mon, 15 Aug 2005 00:30:53 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 15 Aug 2005 00:30:53 +0200

 include/linux/netfilter_ipv4/ip_logging.h  |   20 --------------------
 include/linux/netfilter_ipv6/ip6_logging.h |   20 --------------------
 2 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_logging.h b/include/linux/netfilter_ipv4/ip_logging.h
deleted file mode 100644
--- a/include/linux/netfilter_ipv4/ip_logging.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* IPv4 macros for the internal logging interface. */
-#ifndef __IP_LOGGING_H
-#define __IP_LOGGING_H
-
-#ifdef __KERNEL__
-#include <linux/socket.h>
-#include <linux/netfilter_logging.h>
-
-#define nf_log_ip_packet(pskb,hooknum,in,out,fmt,args...) \
-	nf_log_packet(AF_INET,pskb,hooknum,in,out,fmt,##args)
-
-#define nf_log_ip(pfh,len,fmt,args...) \
-	nf_log(AF_INET,pfh,len,fmt,##args)
-
-#define nf_ip_log_register(logging) nf_log_register(AF_INET,logging)
-#define nf_ip_log_unregister(logging) nf_log_unregister(AF_INET,logging)
-	
-#endif /*__KERNEL__*/
-
-#endif /*__IP_LOGGING_H*/
diff --git a/include/linux/netfilter_ipv6/ip6_logging.h b/include/linux/netfilter_ipv6/ip6_logging.h
deleted file mode 100644
--- a/include/linux/netfilter_ipv6/ip6_logging.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* IPv6 macros for the nternal logging interface. */
-#ifndef __IP6_LOGGING_H
-#define __IP6_LOGGING_H
-
-#ifdef __KERNEL__
-#include <linux/socket.h>
-#include <linux/netfilter_logging.h>
-
-#define nf_log_ip6_packet(pskb,hooknum,in,out,fmt,args...) \
-	nf_log_packet(AF_INET6,pskb,hooknum,in,out,fmt,##args)
-
-#define nf_log_ip6(pfh,len,fmt,args...) \
-	nf_log(AF_INET6,pfh,len,fmt,##args)
-
-#define nf_ip6_log_register(logging) nf_log_register(AF_INET6,logging)
-#define nf_ip6_log_unregister(logging) nf_log_unregister(AF_INET6,logging)
-	
-#endif /*__KERNEL__*/
-
-#endif /*__IP6_LOGGING_H*/

--------------070406080605020101010008--
