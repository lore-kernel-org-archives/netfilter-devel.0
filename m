From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: v3.8-rc3: uninitialized warnings in net/netfilter/xt_CT.c
Date: Thu, 10 Jan 2013 12:47:42 +0100
Message-ID: <20130110114742.GA17883@1984>
References: <20130110111821.GA23008@liondog.tnic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Transfer-Encoding: 8bit
To: Borislav Petkov <bp@alien8.de>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130110111821.GA23008@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Borislav,

On Thu, Jan 10, 2013 at 12:18:21PM +0100, Borislav Petkov wrote:
> Hi,
> 
> I get
> 
> net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v1’:
> net/netfilter/xt_CT.c:250:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v0’:
> net/netfilter/xt_CT.c:112:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Patch attached to address this issue.

--opJtzjQTFsWo+cga
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-xt_CT-fix-unset-return-value-if-conntrack-.patch"
Content-Transfer-Encoding: 8bit

>From 3ceaa3b1baa660aaeef63b86ea9771dcab6d0acd Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 10 Jan 2013 12:42:15 +0100
Subject: [PATCH] netfilter: xt_CT: fix unset return value if conntrack zone
 are disabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v1’:
net/netfilter/xt_CT.c:250:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v0’:
net/netfilter/xt_CT.c:112:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_CT.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 2a08430..bde009e 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -109,7 +109,7 @@ static int xt_ct_tg_check_v0(const struct xt_tgchk_param *par)
 	struct xt_ct_target_info *info = par->targinfo;
 	struct nf_conntrack_tuple t;
 	struct nf_conn *ct;
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (info->flags & ~XT_CT_NOTRACK)
 		return -EINVAL;
@@ -247,7 +247,7 @@ static int xt_ct_tg_check_v1(const struct xt_tgchk_param *par)
 	struct xt_ct_target_info_v1 *info = par->targinfo;
 	struct nf_conntrack_tuple t;
 	struct nf_conn *ct;
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (info->flags & ~XT_CT_NOTRACK)
 		return -EINVAL;
-- 
1.7.10.4


--opJtzjQTFsWo+cga--
