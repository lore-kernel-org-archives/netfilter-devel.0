Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A400FC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 10:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCA5218FD
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 10:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfCUK4N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:56:13 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:48987 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbfCUK4M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 06:56:12 -0400
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h6vMl-00042A-Mj; Thu, 21 Mar 2019 11:56:10 +0100
Date:   Thu, 21 Mar 2019 11:56:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     xiao ruizhu <katrina.xiaorz@gmail.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nf_conntrack_sip: fix rtcp expectation
 clash
Message-ID: <20190321105607.dwj3wtxe32cenglo@salvia>
References: <1552534124-31407-1-git-send-email-katrina.xiaorz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552534124-31407-1-git-send-email-katrina.xiaorz@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Mar 14, 2019 at 11:28:44AM +0800, xiao ruizhu wrote:
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index f067c6b..4398a53 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -799,6 +799,23 @@ static int ct_sip_parse_sdp_addr(const struct nf_conn *ct, const char *dptr,
>  	return 1;
>  }
>  
> +/* Remove conflicting expect created by sip helper for another master
> + * conntrack, most likely related to this master.

Hm, this comment is confusing. Code here that checks that master is
not the same, however, this suggests this is likely the same master,
however, it is related to a different master?

More comments related to the code changes below.

> + */
> +static void release_conflicting_expect(const struct nf_conn *ct,
> +				       const struct nf_conntrack_expect *expect,
> +				       const enum sip_expectation_classes class)
> +{
> +	struct nf_conntrack_expect *exp;
> +	struct net *net = nf_ct_net(ct);
> +

We need to hold the nf_conntrack_expect_lock here, two CPUs may race
to destroy this expectation, unlikely but possible still.

> +	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &expect->tuple);
> +	if (exp && exp->master != ct &&
> +	    nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
> +	    exp->class == class)

I'd suggest you place this into a funcion that we can reuse from
set_expected_rtp_rtcp(), eg.

static bool
nf_ct_sip_expect_exists(const struct nf_conntrack_expect *expect,
                        const struct nf_conn *ct)
{
        return (exp && exp->master != ct &&
                nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
                exp->class == class);
}

So we can reuse it from L927 in set_expected_rtp_rtcp()?

> +		nf_ct_unexpect_related(exp);

Use nf_ct_remove_expect() instead of nf_ct_unexpect_related(), while
holding the spinlock.

And a more general question: Given the scenario you describe is quite
specific, is it not possible to handle this case from
process_sip_response() -> process_prack_response().

Thanks !
