From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next 1/1] netfilter: udplite4: Remove duplicated udplite4 declaration
Date: Wed, 5 Apr 2017 09:58:50 +0800
Message-ID: <002401d2adb0$2bd4a050$837de0f0$@foxmail.com>
References: <1491355395-52913-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <gfree.wind@foxmail.com>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg298.qq.com ([184.105.67.102]:45429 "EHLO smtpbg298.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbdDEB6x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2017 21:58:53 -0400
In-Reply-To: <1491355395-52913-1-git-send-email-gfree.wind@foxmail.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

> -----Original Message-----
> From: gfree.wind@foxmail.com [mailto:gfree.wind@foxmail.com]
> Sent: Wednesday, April 5, 2017 9:23 AM
> To: pablo@netfilter.org; netfilter-devel@vger.kernel.org
> Cc: Gao Feng <fgao@ikuai8.com>
> Subject: [PATCH nf-next 1/1] netfilter: udplite4: Remove duplicated
udplite4
> declaration
> 
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are two nf_conntrack_l4proto_udp4 declarations in the head file
> nf_conntrack_ipv4.h. Now remove one which is not enbraced by the macro
> CONFIG_NF_CT_PROTO_UDPLITE.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/ipv4/nf_conntrack_ipv4.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
> b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
> index 6ff3281..919e4e8 100644
> --- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
> +++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
> @@ -14,7 +14,6 @@
> 
>  extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;  extern
> struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4; -extern struct
> nf_conntrack_l4proto nf_conntrack_l4proto_udplite4;  extern struct
> nf_conntrack_l4proto nf_conntrack_l4proto_icmp;  #ifdef
> CONFIG_NF_CT_PROTO_DCCP  extern struct nf_conntrack_l4proto
> nf_conntrack_l4proto_dccp4;
> --
> 1.9.1
> 
Sorry, please ignore this patch.
Because I find there is another duplicated declaration in IPv6 codes.
So I have sent v2 patch already.

Regards
Feng

