Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AB9C43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 18:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6348F205F4
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 18:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfCFSY0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:24:26 -0500
Received: from mail.us.es ([193.147.175.20]:50816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfCFSYZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 13:24:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A210B190DC0
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 19:24:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D0ADDA846
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 19:24:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8C303DA7FC; Wed,  6 Mar 2019 19:24:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10C81DA84C;
        Wed,  6 Mar 2019 19:24:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Mar 2019 19:24:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E2A364265A2F;
        Wed,  6 Mar 2019 19:24:19 +0100 (CET)
Date:   Wed, 6 Mar 2019 19:24:19 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_osf: Add version option support
Message-ID: <20190306182419.apfiuct6y4bvx34p@salvia>
References: <20190306124435.708-1-ffmancera@riseup.net>
 <20190306161502.ur4zm3arcdcfc6bn@salvia>
 <805cae0b-3458-5bf0-9be0-2698b90d097f@riseup.net>
 <858f9d52-a270-ddbb-ec45-53cdaf5cbd59@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <858f9d52-a270-ddbb-ec45-53cdaf5cbd59@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 06, 2019 at 06:49:12PM +0100, Fernando Fernandez Mancera wrote:
> On 3/6/19 5:55 PM, Fernando Fernandez Mancera wrote:
> > Sorry about the wrong mailing list, it was a mistake. I am fine with
> > your comments so I am going to send a v2. Thanks.
> > 
> > On 3/6/19 5:15 PM, Pablo Neira Ayuso wrote:
> >> Ups, wrong mailing list. For patches use
> >> netfilter-devel@vger.kernel.org, so patchwork catches these patches:
> >>
> >> http://patchwork.ozlabs.org/project/netfilter-devel/list/
> >>
> >> Anyway, no worries, comments below.
> >>
> >> On Wed, Mar 06, 2019 at 01:44:35PM +0100, Fernando Fernandez Mancera wrote:
> >>> Add version option support to the nftables "osf" expression.
> >>>
> >>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> >>> ---
> >>>  include/linux/netfilter/nfnetlink_osf.h  | 11 ++++++---
> >>>  include/uapi/linux/netfilter/nf_tables.h |  6 +++++
> >>>  net/netfilter/nfnetlink_osf.c            | 14 +++++------
> >>>  net/netfilter/nft_osf.c                  | 31 ++++++++++++++++++++----
> >>>  4 files changed, 47 insertions(+), 15 deletions(-)
> >>>
> >>> diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
> >>> index c6000046c966..788613f36935 100644
> >>> --- a/include/linux/netfilter/nfnetlink_osf.h
> >>> +++ b/include/linux/netfilter/nfnetlink_osf.h
> >>> @@ -21,13 +21,18 @@ struct nf_osf_finger {
> >>>  	struct nf_osf_user_finger	finger;
> >>>  };
> >>>  
> [...]
> >>>  
> >>>  #endif /* _NFOSF_H */
> >>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> >>> index a66c8de006cc..39bbb79ef4c2 100644
> >>> --- a/include/uapi/linux/netfilter/nf_tables.h
> >>> +++ b/include/uapi/linux/netfilter/nf_tables.h
> >>> @@ -1522,15 +1522,21 @@ enum nft_flowtable_hook_attributes {
> >>>   *
> >>>   * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
> >>>   * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
> >>> + * @NFTA_OSF_FLAGS: flags (NLA_U8)
> >>
> >> Please, use NLA_U32 for this.
> >>
> 
> Do you mean all osf "flags" attribute right? So I am going to do the
> proper changes in nft, libnftnl and nf-next.

Yes. Use NLA_U32 for flags. Remember to deal with endianess via
ntohl() and htonl().

> [...]
> >>> @@ -47,6 +57,7 @@ static int nft_osf_init(const struct nft_ctx *ctx,
> >>>  			const struct nlattr * const tb[])
> >>>  {
> >>>  	struct nft_osf *priv = nft_expr_priv(expr);
> >>> +	u8 flags;
> >>>  	int err;
> >>>  	u8 ttl;
> >>>  
> >>> @@ -57,6 +68,13 @@ static int nft_osf_init(const struct nft_ctx *ctx,
> >>>  		priv->ttl = ttl;
> >>>  	}
> >>>  
> >>> +	if (tb[NFTA_OSF_FLAGS]) {
> >>> +		flags = nla_get_u8(tb[NFTA_OSF_FLAGS]);
> >>
> >> If you turn this into a NLA_U32, then you have to use here.
> >>
> >>                 flags = ntohl(nla_get_be32(tb[NFTA_OSF_FLAGS]));
> >>
> >>> +		if (flags != NFT_OSF_F_VERSION && flags != 0)
> >>
> >> No need to restrict flags != 0, remove that part of the check.
> >>
> 
> I think we need this restriction because if we do not set "version"
> option the "flags" value is 0. If we remove that part of the check we
> are forcing to use "version" option always.

We can send the NFTA_OSF_FLAGS attribute from userspace, but set it to
zero, it's valid to set flags to zero, actually this is the default
value (when no NFTA_OSF_FLAGS is sent from userspace).
