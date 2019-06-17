Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B651EC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91CD62080C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFQWhT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:37:19 -0400
Received: from mail.us.es ([193.147.175.20]:34680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfFQWhT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 18:37:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B7BFBEBC1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:37:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C57CDA702
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:37:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CC46DDA705; Tue, 18 Jun 2019 00:37:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE268DA704;
        Tue, 18 Jun 2019 00:37:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 00:37:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 815F34265A2F;
        Tue, 18 Jun 2019 00:37:13 +0200 (CEST)
Date:   Tue, 18 Jun 2019 00:37:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     xiao ruizhu <katrina.xiaorz@gmail.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        alin.nastac@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v6] netfilter: nf_conntrack_sip: fix expectation clash
Message-ID: <20190617223713.36ozdeh4hm6efv4y@salvia>
References: <20190610174543.chflcq4udmpqitnu@salvia>
 <1560230459-3911-1-git-send-email-katrina.xiaorz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560230459-3911-1-git-send-email-katrina.xiaorz@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 11, 2019 at 01:20:59PM +0800, xiao ruizhu wrote:
> > On Tue, Jun 11, 2019 at 01:45AM, Pablo Neira Ayuso <pablo@netfilter.org>
> > wrote:
> 
> > Looks good, only one more little change and we go.
> 
> >> On Tue, Jun 04, 2019 at 04:34:23PM +0800, xiao ruizhu wrote:
> >> [...]
> >> @@ -420,8 +421,10 @@ static inline int __nf_ct_expect_check(struct
> >> nf_conntrack_expect *expect)
> >>       }
> >>       h = nf_ct_expect_dst_hash(net, &expect->tuple);
> >>       hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
> >> -           if (expect_matches(i, expect)) {
> >> -                   if (i->class != expect->class)
> >> +           if ((flags & NF_CT_EXP_F_CHECK_MASTER ? true : i->master ==
> >> +               expect->master) && expect_matches(i, expect)) {
> > 
> > Could you add a function for this? eg.
> > 
> > static bool nf_ct_check_master(struct nf_conntrack_expect *a,
> >                                struct nf_conntrack_expect *b)
> > {
> >         if (flags & NF_CT_EXP_F_CHECK_MASTER)
> >                 return true;
> > 
> >         return i->master == expect->master &&
> >                expect_matches(i, expect);
> > }
> 
> > Was that the intention?
> 
> > I'm a bit confused with the use of the single statement branch above.
> 
> Hi Pablo,
> 
> Thanks for your notice.
> Sorry, I made a mistake here. I meant to move the checking of master from
> expect_matches() to __nf_ct_expect_check(), where we will use the flag
> NF_CT_EXP_F_CHECK_MASTER to decide whether masters also need to be checked
> or not for matching.
> That is, the intention is to change expect_matches() from the original
> {
>         return a->master == b->master &&
>                nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
>                nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
>                net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
>                nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
> }
> to
> {
>         return nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
>                nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
>                net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
>                nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
> }
> And in __nf_ct_expect_check(), if the expect is for SIP helper (i.e. with
> NF_CT_EXP_F_CHECK_MASTER set), the master will not be checked, only the
> items in new expect_matches() will be used for matching check; otherwise,
> masters will also be checked. That's the purpose of (flags &
> NF_CT_EXP_F_CHECK_MASTER ? true : i->master == expect->master).
[...]
> @@ -420,8 +420,10 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
>  	}
>  	h = nf_ct_expect_dst_hash(net, &expect->tuple);
>  	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
> -		if (expect_matches(i, expect)) {
> -			if (i->class != expect->class)
> +		if ((flags & NF_CT_EXP_F_CHECK_MASTER ? true : i->master ==
> +		    expect->master) && expect_matches(i, expect)) {

This part is slightly hard to read. Could you add a function? For
example:

static bool master_matches(...)
{
        if (flags & NF_CT_EXP_F_CHECK_MASTER)
                return true;

        return i->master == expect->master;
}

Then use it:

                 if (master_matches(i, expect) &&
                     expect_matches(i, expect)) {
> +			if (i->class != expect->class ||
> +			    i->master != expect->master)
>  				return -EALREADY;
>  
>  			if (nf_ct_remove_expect(i))

Thanks!
