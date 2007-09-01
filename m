From: Peter Riley <Peter.Riley@hotpop.com>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Sat, 01 Sep 2007 12:57:01 -0700
Message-ID: <46D9C40D.6030001@hotpop.com>
References: <46D06522.2090509@hotpop.com>	<46D06FF8.5090004@hotpop.com>	<46D5A5B9.2030107@trash.net>	<46D6DEAF.9010009@hotpop.com>	<Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>	<46D824EA.1060406@hotpop.com>	<46D83F90.5060600@trash.net>
	<46D9BE2A.4070901@hotpop.com>
Reply-To: Peter.Riley@hotpop.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010207070008000005050402"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Peter.Riley@hotpop.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D9BE2A.4070901@hotpop.com>
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
--------------010207070008000005050402
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Peter Riley wrote:
> 
> p-o-m-ng probably needs patching now too.  I'll take a look...

A quick check found four occurrences.
These two are in old kernel code.

patchlets/TARPIT/linux/net/ipv4/netfilter/ipt_TARPIT.c
-	nskb->nfcache = 0;

patchlets/IPV4OPTSSTRIP/linux/net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c
-	skb->nfcache |= NFC_ALTERED;


But these two are in match extensions.  See patch.

patchlets/ipv4options/iptables/extensions/libipt_ipv4options.c
patchlets/u32/iptables/extensions/libipt_u32.c


Best Regards,
Peter




--------------010207070008000005050402
Content-Type: text/plain;
 name="pom-ng-nfcache-enema2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pom-ng-nfcache-enema2.patch"

Index: patchlets/ipv4options/iptables/extensions/libipt_ipv4options.c
===================================================================
--- patchlets/ipv4options/iptables/extensions/libipt_ipv4options.c	(revision 7013)
+++ patchlets/ipv4options/iptables/extensions/libipt_ipv4options.c	(working copy)
@@ -40,7 +40,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      unsigned int *nfcache,
       struct ipt_entry_match **match)
 {
 	struct ipt_ipv4options_info *info = (struct ipt_ipv4options_info *)(*match)->data;
Index: patchlets/u32/iptables/extensions/libipt_u32.c
===================================================================
--- patchlets/u32/iptables/extensions/libipt_u32.c	(revision 7013)
+++ patchlets/u32/iptables/extensions/libipt_u32.c	(working copy)
@@ -93,7 +93,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      unsigned int *nfcache,
       struct ipt_entry_match **match)
 {
 	struct ipt_u32 *data = (struct ipt_u32 *)(*match)->data;






--------------010207070008000005050402--
