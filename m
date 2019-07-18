Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45A8C7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 18:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8679E2083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 18:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfGRSM6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 14:12:58 -0400
Received: from mail.us.es ([193.147.175.20]:35792 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbfGRSM5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 14:12:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B065B60C3
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 20:12:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE59FDA732
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 20:12:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4276DA704; Thu, 18 Jul 2019 20:12:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EFE1C203F1;
        Thu, 18 Jul 2019 20:12:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Jul 2019 20:12:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CB8D84265A32;
        Thu, 18 Jul 2019 20:12:53 +0200 (CEST)
Date:   Thu, 18 Jul 2019 20:12:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fwestpha@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] net: nf_tables: Make nft_meta expression more robust
Message-ID: <20190718181253.dh6thcfxhnqdz74s@salvia>
References: <20190718033729.12438-1-phil@nwl.cc>
 <20190718181034.gwe5tu4z2j4m7zyv@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718181034.gwe5tu4z2j4m7zyv@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 18, 2019 at 08:10:34PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 18, 2019 at 05:37:29AM +0200, Phil Sutter wrote:
> > nft_meta_get_eval()'s tendency to bail out setting NFT_BREAK verdict in
> > situations where required data is missing breaks inverted checks
> > like e.g.:
> > 
> > | meta iifname != eth0 accept
> > 
> > This rule will never match if there is no input interface (or it is not
> > known) which is not intuitive and, what's worse, breaks consistency of
> > iptables-nft with iptables-legacy.
> > 
> > Fix this by falling back to placing a value in dreg which never matches
> > (avoiding accidental matches):
> > 
> > {I,O}IF:
> > 	Use invalid ifindex value zero.
> > 
> > {I,O}IFNAME, {I,O}IFKIND:
> > 	Use an empty string which is neither a valid interface name nor
> > 	kind.
> > 
> > {I,O}IFTYPE:
> > 	Use ARPHRD_VOID (0xFFFF).
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/nft_meta.c | 45 +++++++++++++++++-----------------------
> 
> Missing update for:
> 
>  net/bridge/netfilter/nft_meta_bridge.c

While you update this, would you also disentangle the default: case?

        default:
                goto out;

        ...
out:
        return nft_meta_get_eval(expr, regs, pkt);

not good to use goto like that.

I'd suggest:

        default:
                nft_meta_get_eval(expr, regs, pkt);
                return;

Thanks.
