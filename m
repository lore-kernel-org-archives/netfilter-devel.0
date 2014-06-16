From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: add zone size to length
Date: Mon, 16 Jun 2014 13:56:29 +0200
Message-ID: <20140616115629.GA10734@localhost>
References: <CAGCkEt29_QnR1N9+oPQt7mX=6_0GF0oTsT4WgTz_ajGyef+Odg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57800 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaFPL4j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:56:39 -0400
Content-Disposition: inline
In-Reply-To: <CAGCkEt29_QnR1N9+oPQt7mX=6_0GF0oTsT4WgTz_ajGyef+Odg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 12, 2014 at 08:34:55AM +0900, Ken-ichirou MATSUZAWA wrote:
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>

Applied, thanks.

>  net/netfilter/nf_conntrack_netlink.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c
> b/net/netfilter/nf_conntrack_netlink.c
> index 5857963..e279b76 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -597,6 +597,9 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
>  #ifdef CONFIG_NF_CONNTRACK_MARK
>                + nla_total_size(sizeof(u_int32_t)) /* CTA_MARK */
>  #endif
> +#ifdef CONFIG_NF_CONNTRACK_ZONES
> +              + nla_total_size(sizeof(u_int16_t)) /* CTA_ZONE */
> +#endif
>                + ctnetlink_proto_size(ct)
>                + ctnetlink_label_size(ct)
>                ;
> @@ -2040,6 +2043,9 @@ ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
>  #ifdef CONFIG_NF_CONNTRACK_MARK
>                + nla_total_size(sizeof(u_int32_t)) /* CTA_MARK */
>  #endif
> +#ifdef CONFIG_NF_CONNTRACK_ZONES
> +              + nla_total_size(sizeof(u_int16_t)) /* CTA_ZONE */
> +#endif
>                + ctnetlink_proto_size(ct)
>                ;
>  }
> --
> 1.7.10.4
