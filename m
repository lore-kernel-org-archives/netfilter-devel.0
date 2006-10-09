From: Patrick McHardy <kaber@trash.net>
Subject: Re: Compiling 1.3.6
Date: Mon, 09 Oct 2006 17:23:01 +0200
Message-ID: <452A6955.6020100@trash.net>
References: <00be01c6e977$1ba6bcd0$0101a8c0@pcjorge>
	<452979F7.9090205@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010907020403010904010904"
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <452979F7.9090205@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010907020403010904010904
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> min_ip and max_ip type has been changed from u_int32_t to __be32 that is
> not defined in userspace, this breaks iptables compilation. Attached a
> patch that recovers the use of u_int32_t. I'm not sure if this is the
> best fix so let me know what you think.

I think we should just define the endian-annotation types in userspace.
Does this patch fix compilation?


--------------010907020403010904010904
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/iptables_common.h
===================================================================
--- include/iptables_common.h	(Revision 6660)
+++ include/iptables_common.h	(Arbeitskopie)
@@ -42,4 +42,9 @@
   extern void init_extensions(void);
 #endif
 
+#define __be32	u_int32_t
+#define __le32	u_int32_t
+#define __be16	u_int16_t
+#define __le16	u_int16_t
+
 #endif /*_IPTABLES_COMMON_H*/

--------------010907020403010904010904--
