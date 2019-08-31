Return-Path: <SRS0=T6Q7=W3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C207C3A5A8
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 14:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0857722DA9
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 14:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfHaOWX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Aug 2019 10:22:23 -0400
Received: from correo.us.es ([193.147.175.20]:46454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfHaOWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Aug 2019 10:22:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BDE97DA709
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Aug 2019 16:22:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE75ED1911
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Aug 2019 16:22:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3D0BDA4D0; Sat, 31 Aug 2019 16:22:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84DAADA72F;
        Sat, 31 Aug 2019 16:22:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Aug 2019 16:22:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6395F4265A5A;
        Sat, 31 Aug 2019 16:22:16 +0200 (CEST)
Date:   Sat, 31 Aug 2019 16:22:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@resnulli.us
Subject: Re: [PATCH 0/4 net-next] flow_offload: update mangle action
 representation
Message-ID: <20190831142217.bvxx3vc6wpsmnxpe@salvia>
References: <20190830005336.23604-1-pablo@netfilter.org>
 <20190829185448.0b502af8@cakuba.netronome.com>
 <20190830090710.g7q2chf3qulfs5e4@salvia>
 <20190830153351.5d5330fa@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830153351.5d5330fa@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 30, 2019 at 03:33:51PM -0700, Jakub Kicinski wrote:
> On Fri, 30 Aug 2019 11:07:10 +0200, Pablo Neira Ayuso wrote:
> > > > * The front-end coalesces consecutive pedit actions into one single
> > > >   word, so drivers can mangle IPv6 and ethernet address fields in one
> > > >   single go.  
> > > 
> > > You still only coalesce up to 16 bytes, no?  
> > 
> > You only have to rise FLOW_ACTION_MANGLE_MAXLEN coming in this patch
> > if you need more. I don't know of any packet field larger than 16
> > bytes. If there is a use-case for this, it should be easy to rise that
> > definition.
> 
> Please see the definitions of:
> 
> struct nfp_fl_set_eth
> struct nfp_fl_set_ip4_addrs
> struct nfp_fl_set_ip4_ttl_tos
> struct nfp_fl_set_ipv6_tc_hl_fl
> struct nfp_fl_set_ipv6_addr
> struct nfp_fl_set_tport
> 
> These are the programming primitives for header rewrites in the NFP.
> Since each of those contains more than just one field, we'll have to
> keep all the field coalescing logic in the driver, even if you coalesce
> while fields (i.e. IPv6 addresses).

nfp has been updated in this patch series to deal with the new mangle
representation.

> Perhaps it's not a serious blocker for the series, but it'd be nice if
> rewrite action grouping was handled in the core. Since you're already
> poking at that code..

Rewrite action grouping is already handled from the core front-end in
this patch series.

Thanks.
