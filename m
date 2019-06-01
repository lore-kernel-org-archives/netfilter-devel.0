Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D68C04AB6
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 00:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BABD426FD8
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 00:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfFAAWf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 20:22:35 -0400
Received: from mail.us.es ([193.147.175.20]:40736 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfFAAWf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 20:22:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 20FFDE2D9A
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 02:22:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10A8DDA708
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 02:22:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06413DA706; Sat,  1 Jun 2019 02:22:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DB0DDA701;
        Sat,  1 Jun 2019 02:22:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 02:22:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DEAFE4265A31;
        Sat,  1 Jun 2019 02:22:30 +0200 (CEST)
Date:   Sat, 1 Jun 2019 02:22:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190601002230.bo6dhdf3lhlkknqq@salvia>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190531193558.GB4276@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 03:35:58PM -0400, Stephen Suryaputra wrote:
> On Fri, May 31, 2019 at 07:11:01PM +0200, Pablo Neira Ayuso wrote:
> > > +/* find the offset to specified option or the header beyond the options
> > > + * if target < 0.
> > > + *
> > > + * Note that *offset is used as input/output parameter, and if it is not zero,
> > > + * then it must be a valid offset to an inner IPv4 header. This can be used
> > > + * to explore inner IPv4 header, eg. ICMP error messages.
> > 
> > In other extension headers (IPv6 and TCP options) this offset is used
> > to match for a field inside the extension / option.
> > 
> > So this semantics you describe here are slightly different, right?
> 
> It is the same as the IPv6 one. The offset returned is the offset to the
> specific option (target) or the byte beyond the options if the target
> isn't specified (< 0).

Thanks for explaining. So you are using ipv6_find_hdr() as reference,
but not sure this offset parameter is useful for this patchset since
this is always set to zero, do you have plans to use this in a follow
up patchset?

[...]
> > > +			if (tb[NFTA_EXTHDR_DREG])
> > > +				return &nft_exthdr_ipv4_ops;
> > > +		}
> > > +		break;
> > 
> > Then, from the _eval() path:
> > 
> > You have to replace iph->version == 4 check abive, you could use
> > skb->protocol instead, and check for htons(ETH_P_IP) packets.
> 
> A bit lost. Did you mean this?
> 
> static int ipv4_find_option(struct net *net, struct sk_buff *skb,
> »       »       »           unsigned int *offset, int target,
> »       »       »           unsigned short *fragoff, int *flags)
> {
> 	...
> »       iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
> »       if (!iph || skb->protocol != htons(ETH_P_IP))
> »       »       return -EBADMSG;

I mean, you make this check upfront from the _eval() path, ie.

static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
                                 ...
{
        ...

        if (skb->protocol != htons(ETH_P_IP))
                goto err;

Thanks.
