Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6904ECE58F
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 21:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 476302064B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 21:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Q/FgKW5q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbfJOVGy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 17:06:54 -0400
Received: from kadath.azazel.net ([81.187.231.250]:39212 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388525AbfJOVGx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 17:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vb9Fu3V1EpP83cgt0YS9QphyyzK+0xdHJxOJDT+gs8w=; b=Q/FgKW5qfxAh49Pm/9GDHKWtEQ
        hbQXFEHTVR+ZcT7hCaE52XwWSZNkUw0j7NiBSLjTshepKARqPDHxQ4LFL5GtfFpC48dQU6tYGyHk0
        nlMiSPBwySkYus60ss7+Xwv3SVkNl5E3X8lTA67wiHxZ/cM5crctWnQf/6RzNaG20XWW5MnG7J18/
        6sjd6RietMnz/SMsKWIz+aY9e9T6GU2Chpc5ab/bzmNE4Y4tugvfhvlB70Kj7wZGwdjO1U58O3F4k
        DSTuKrny+IWFMW9/dcJThTKuoxLdKCYbZ1dJLLJgwEO045uXxlIUw+RIjVP07Whojyjmw3X5mwHDA
        x4wb4WvA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iKU1p-0005Lr-2a; Tue, 15 Oct 2019 22:06:49 +0100
Date:   Tue, 15 Oct 2019 22:06:48 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: don't dump ct extensions
 of unconfirmed conntracks
Message-ID: <20191015210647.GA16877@azazel.net>
References: <20191014194141.17626-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20191014194141.17626-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-10-14, at 21:41:41 +0200, Florian Westphal wrote:
> When dumping the unconfirmed lists, the cpu that is processing the ct
> entry can realloc ct->ext at any time.
>
> Accessing extensions from another CPU is ok provided rcu read lock is
> held.
>
> Once extension space will be reallocated with plain krealloc this
> isn't used anymore.
>
> Dumping the extension area for confirmed or dying conntracks is fine:
> no reallocations are allowed and list iteration holds appropriate
> locks that prevent ct (and thus ct->ext) from getting free'd.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 77 ++++++++++++++++++----------
>  1 file changed, 51 insertions(+), 26 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index e2d13cd18875..db04e1bfb04d 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -506,9 +506,44 @@ static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
>  	return -1;
>  }
>
> +/* all these functions access ct->ext. Caller must either hold a reference
> + * on ct or prevent its deletion by holding either the bucket spinlock or
> + * pcpu dying list lock.
> + */
> +static int ctnetlink_dump_extinfo(struct sk_buff *skb,
> +				  const struct nf_conn *ct, u32 type)
> +{
> +	if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
> +	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
> +	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
> +	    ctnetlink_dump_labels(skb, ct) < 0 ||
> +	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
> +	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
> +{
> +	if (ctnetlink_dump_status(skb, ct) < 0 ||
> +	    ctnetlink_dump_mark(skb, ct) < 0 ||
> +	    ctnetlink_dump_secctx(skb, ct) < 0 ||
> +	    ctnetlink_dump_id(skb, ct) < 0 ||
> +	    ctnetlink_dump_use(skb, ct) < 0 ||
> +	    ctnetlink_dump_master(skb, ct) < 0)
> +		return -1;
> +
> +	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
> +	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
> +	     ctnetlink_dump_protoinfo(skb, ct) < 0))
> +
> +	return 0;
> +}
> +
>  static int
>  ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
> -		    struct nf_conn *ct)
> +		    struct nf_conn *ct, bool extinfo)
>  {
>  	const struct nf_conntrack_zone *zone;
>  	struct nlmsghdr *nlh;
> @@ -552,23 +587,9 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  				   NF_CT_DEFAULT_ZONE_DIR) < 0)
>  		goto nla_put_failure;
>
> -	if (ctnetlink_dump_status(skb, ct) < 0 ||
> -	    ctnetlink_dump_acct(skb, ct, type) < 0 ||
> -	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
> -	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
> -	    ctnetlink_dump_mark(skb, ct) < 0 ||
> -	    ctnetlink_dump_secctx(skb, ct) < 0 ||
> -	    ctnetlink_dump_labels(skb, ct) < 0 ||
> -	    ctnetlink_dump_id(skb, ct) < 0 ||
> -	    ctnetlink_dump_use(skb, ct) < 0 ||
> -	    ctnetlink_dump_master(skb, ct) < 0 ||
> -	    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
> -	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
> +	if (ctnetlink_dump_info(skb, ct) < 0)
>  		goto nla_put_failure;
> -
> -	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
> -	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
> -	     ctnetlink_dump_protoinfo(skb, ct) < 0))
> +	if (extinfo && ctnetlink_dump_extinfo(skb, ct, type) < 0)
>  		goto nla_put_failure;
>
>  	nlmsg_end(skb, nlh);
> @@ -953,13 +974,11 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
>  			if (!ctnetlink_filter_match(ct, cb->data))
>  				continue;
>
> -			rcu_read_lock();
>  			res =
>  			ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
>  					    cb->nlh->nlmsg_seq,
>  					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
> -					    ct);
> -			rcu_read_unlock();
> +					    ct, true);
>  			if (res < 0) {
>  				nf_conntrack_get(&ct->ct_general);
>  				cb->args[1] = (unsigned long)ct;
> @@ -1364,10 +1383,8 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
>  		return -ENOMEM;
>  	}
>
> -	rcu_read_lock();
>  	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
> -				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct);
> -	rcu_read_unlock();
> +				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true);
>  	nf_ct_put(ct);
>  	if (err <= 0)
>  		goto free;
> @@ -1429,12 +1446,20 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
>  					continue;
>  				cb->args[1] = 0;
>  			}
> -			rcu_read_lock();
> +
> +			/* We can't dump extension info for the unconfirmed
> +			 * list because unconfirmed conntracks can have ct->ext
> +			 * reallocated (and thus freed).
> +			 *
> +			 * In the dying list case ct->ext can't be altered during
> +			 * list walk anymore, and free can only occur after ct
> +			 * has been unlinked from the dying list (which can't
> +			 * happen until after we drop pcpu->lock).
> +			 */
>  			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
>  						  cb->nlh->nlmsg_seq,
>  						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
> -						  ct);
> -			rcu_read_unlock();
> +						  ct, dying ? true : false);

s/dying ? true : false/dying/

>  			if (res < 0) {
>  				if (!atomic_inc_not_zero(&ct->ct_general.use))
>  					continue;
> --
> 2.21.0
>
>

J.

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2mNN8ACgkQ0Z7UzfnX
9sMT9A//abBlLmD74WOJsJ2kSfZBniO2NDeGCcFG6A15uhDgMG0xc39Z9KXsaTuv
//I7N56n5uZY/5xqZNoStyinLIyusQNXV8U471YskwpLDyD6c6QoGwbozf3nJipk
LjWupTWJkIeex/0LhTeDndDPZXuPwsR7V5aQZzsQsfIdFieced65v7cXYNem2TF1
745Vdl5KRMWoNNq/9vfvRp1du6wqOABNd/Nf+CoNoi8b8c5bqB7Q0kwhpNqn9c62
bMUQhgsZxDfQmrzv31ya71XopLf0Jtyv4mzS0iZQsyv+9OyhzDGoKn2sWQ1LZoN2
KuyvrIYTmOVevav3SqERNNeNgDAkLDXmfNTv6MfcmR1A+Q1nCmQQXI/uo/yAtNM7
ox7d6Iakf6XkIb1hCnR7SDEz+sd4VlKk19HQUaRsjnDM1a37hTXlk5qbAQQtK1Bb
IhBmASmVWhOLBc5GGat5x/48Kw4G3V2nkEEntbyFlMQ06AAEb7WmESk98Gfa1gbw
Fzq98yVO1/CZgciFJL6KzHapYwT3Tl4Jc+5A5cqIvEdt/o/jCd9PNFoTuggqNpic
PVReT9rKI0Fuz0BnK09QR/OJZdpFYIqB1DW50WfeQ9oVLLw1sytietTMU1JBpQMn
no0RTvoct54qrMsjRXMkDXUZxZJofagH7ictQ5pg98XyZwsDrQA=
=MNBI
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
