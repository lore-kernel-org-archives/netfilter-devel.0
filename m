From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: [PATCH] 2.6.17 API changes for ipp2p, time
Date: Sat, 24 Jun 2006 15:51:06 +0200
Message-ID: <1151157066.29998.28.camel@scaramouche.combox.de>
References: <1151096311.3421.10.camel@murdegern.hindenburgdamm.example>
	<Pine.LNX.4.64.0606240900140.26102@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-wbjHunSbTXWGHdckmq6x"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0606240900140.26102@bizon.gios.gov.pl>
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


--=-wbjHunSbTXWGHdckmq6x
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sa, 2006-06-24 at 09:13 +0200, Krzysztof Oledzki wrote:
>=20
> So, please send ipp2p and time (with CC to me)=20
> and patches that only corrects API in the "linux-2.6" directory .

Ok, here you are...

Regards,
Torsten L=C3=BCttgert


--=-wbjHunSbTXWGHdckmq6x
Content-Disposition: attachment; filename=ipp2p.patch
Content-Type: text/x-patch; name=ipp2p.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c
===================================================================
--- ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	(revision 6631)
+++ ipp2p/linux-2.6/net/ipv4/netfilter/ipt_ipp2p.c	(working copy)
@@ -728,6 +728,7 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -811,7 +812,8 @@
 
 static int
 checkentry(const char *tablename,
-            const void *ip,
+	    const void *ip,
+	    const struct xt_match *match,
 	    void *matchinfo,
 	    unsigned int matchsize,
 	    unsigned int hook_mask)

--=-wbjHunSbTXWGHdckmq6x
Content-Disposition: attachment; filename=time.patch
Content-Type: text/x-patch; name=time.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: time/linux-2.6/net/ipv4/netfilter/ipt_time.c
===================================================================
--- time/linux-2.6/net/ipv4/netfilter/ipt_time.c	(revision 6631)
+++ time/linux-2.6/net/ipv4/netfilter/ipt_time.c	(working copy)
@@ -46,6 +46,7 @@
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -83,6 +84,7 @@
 static int
 checkentry(const char *tablename,
            const void *ip,
+           const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
            unsigned int hook_mask)

--=-wbjHunSbTXWGHdckmq6x--
