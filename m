From: =?utf-8?B?TcOhdMOp?= Eckl <ecklm94@gmail.com>
Subject: Re: linux-next: Tree for Aug 2 (netfilter: tproxy)
Date: Thu, 2 Aug 2018 21:05:57 +0200
Message-ID: <20180802190557.sha6wer6gkdgrd6i@sch.bme.hu>
References: <20180802193111.346fdde9@canb.auug.org.au>
 <0185f82e-4bf5-6c6c-a131-ba2c0197c9a0@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nwyw3czl35l47w5e"
Content-Transfer-Encoding: 8bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        pablo@netfilter.org
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0185f82e-4bf5-6c6c-a131-ba2c0197c9a0@infradead.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--nwyw3czl35l47w5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Randy,

Thanks for reporting!

Please find the patch attached.

Regards,
Mate

On Thu, Aug 02, 2018 at 09:28:16AM -0700, Randy Dunlap wrote:
> On 08/02/2018 02:31 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20180801:
> > 
> 
> on i386:
> 
> ../net/netfilter/nft_tproxy.c: In function 'nft_tproxy_init':
> ../net/netfilter/nft_tproxy.c:237:3: error: implicit declaration of function 'nf_defrag_ipv6_enable' [-Werror=implicit-function-declaration]
>    err = nf_defrag_ipv6_enable(ctx->net);
> 
> 
> Full randconfig file is attached.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> 
> -- 
> ~Randy

--nwyw3czl35l47w5e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-netfilter-nft_tproxy-Add-missing-config-check.patch"
Content-Transfer-Encoding: 8bit

>From 2c3a7d3209ed5e539ecd69192fc0f4186fdc7d99 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>
Date: Thu, 2 Aug 2018 20:46:13 +0200
Subject: [PATCH] netfilter: nft_tproxy: Add missing config check
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A config check was missing form the code when using
nf_defrag_ipv6_enable with NFT_TPROXY != n and NF_DEFRAG_IPV6 = n and
this caused the following error in case of :

../net/netfilter/nft_tproxy.c: In function 'nft_tproxy_init':
../net/netfilter/nft_tproxy.c:237:3: error: implicit declaration of function
+'nf_defrag_ipv6_enable' [-Werror=implicit-function-declaration]
   err = nf_defrag_ipv6_enable(ctx->net);

This patch adds a check for NF_TABLES_IPV6 when NF_DEFRAG_IPV6 is
selected by Kconfig.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
---
 net/netfilter/nft_tproxy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index c6845f7baa08..eff99dffc842 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -234,9 +234,11 @@ static int nft_tproxy_init(const struct nft_ctx *ctx,
 		err = nf_defrag_ipv4_enable(ctx->net);
 		if (err)
 			return err;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 		err = nf_defrag_ipv6_enable(ctx->net);
 		if (err)
 			return err;
+#endif
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
ecklm


--nwyw3czl35l47w5e--
