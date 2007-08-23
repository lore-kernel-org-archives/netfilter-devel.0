From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_ipv4 must be loaded explicitly
Date: Thu, 23 Aug 2007 16:53:28 +0200
Message-ID: <46CD9F68.2060902@trash.net>
References: <Pine.LNX.4.64.0708021937140.9319@fbirervta.pbzchgretzou.qr> <46B22364.9060506@trash.net> <Pine.LNX.4.64.0708171242450.5492@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010207060406080807010007"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764812AbXHWOzk@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708171242450.5492@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010207060406080807010007
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Aug 2 2007 20:33, Patrick McHardy wrote:
> 
>>>End result:
>>>
>>>After loading nf_conntrack_ipv4.ko, everything works again (also with the
>>>"bad" ff09b7). But I have to load it explicitly, and I think that
>>>unfortunately breaks a lot of setups (such as mine) which assume ipv4
>>>connection tracking is always there.
>>
>>I already have a patch for this queued. I'll push it upstream once
>>I get a new power supply for the box I keep that tree on, hopefully
>>tommorrow.
> 
> 
> What's that patch looking like?


Upstream commit 591e6206. Doesn't it work for you?

--------------010207060406080807010007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_nat: add symbolic dependency on IPv4 conntrack

Loading nf_nat causes the conntrack core to be loaded, but we need IPv4 as
well.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 591e620693e71e24fb3450a4084217e44b7a60b6
tree e651e7beaca45a99b89bd63d33419c5b97477a28
parent ff4ca8273eafbba875a86d333e059e78f292107f
author Patrick McHardy <kaber@trash.net> Tue, 07 Aug 2007 18:12:01 -0700
committer David S. Miller <davem@davemloft.net> Tue, 07 Aug 2007 18:12:01 -0700

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    2 ++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    6 ++++++
 net/ipv4/netfilter/nf_nat_standalone.c         |    2 +-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 7a67160..9bf0598 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -21,4 +21,6 @@ extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 extern int nf_conntrack_ipv4_compat_init(void);
 extern void nf_conntrack_ipv4_compat_fini(void);
 
+extern void need_ipv4_conntrack(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 64552af..d9b5177 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -509,3 +509,9 @@ static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 
 module_init(nf_conntrack_l3proto_ipv4_init);
 module_exit(nf_conntrack_l3proto_ipv4_fini);
+
+void need_ipv4_conntrack(void)
+{
+	return;
+}
+EXPORT_SYMBOL_GPL(need_ipv4_conntrack);
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 332814d..46cc99d 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -328,7 +328,7 @@ static int __init nf_nat_standalone_init(void)
 {
 	int ret = 0;
 
-	need_conntrack();
+	need_ipv4_conntrack();
 
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);

--------------010207060406080807010007--
