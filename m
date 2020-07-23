Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7ACC433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 12:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641FA20792
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 12:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgGWMXD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:23:03 -0400
Received: from correo.us.es ([193.147.175.20]:40692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgGWMXD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 08:23:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43BA4FA52D
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 14:23:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3214FDA84F
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 14:23:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 277A7DA84D; Thu, 23 Jul 2020 14:23:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F5B5DA72F;
        Thu, 23 Jul 2020 14:22:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 Jul 2020 14:22:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 445354265A2F;
        Thu, 23 Jul 2020 14:22:58 +0200 (CEST)
Date:   Thu, 23 Jul 2020 14:22:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/18] nft: Sorted chain listing et al.
Message-ID: <20200723122257.GA22824@salvia>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 11, 2020 at 12:18:13PM +0200, Phil Sutter wrote:
> Work in this series centered around Harald's complaint about seemingly
> random custom chain ordering in iptables-nft-save output. nftables
> returns chains in the order they were created which differs from
> legacy iptables which sorts by name.
> 
> The intuitive approach of simply sorting chains in tables'
> nftnl_chain_lists is problematic since base chains, which shall be
> dumped first, are contained in there as well. Patch 15 solves this by
> introducing a per-table array of nftnl_chain pointers to hold only base
> chains (the hook values determine the array index). The old
> nftnl_chain_list now contains merely non-base chains and is sorted upon
> population by the new nftnl_chain_list_add_sorted() function.
> 
> Having dedicated slots for base chains allows for another neat trick,
> namely to create only immediately required base chains. Apart from the
> obvious case, where adding a rule to OUTPUT chain doesn't cause creation
> of INPUT or FORWARD chains, this means ruleset modifications can be
> avoided completely when listing, flushing or zeroing counters (unless
> chains exist).

Patches from 1 to 7, they look good to me. Would it be possible to
apply these patches independently from this batch or they are a strong
dependency?

I think it's better if we go slightly different direction?

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200723121553.7400-1-pablo@netfilter.org/

Instead of adding more functions into libnftnl for specific list
handling, which are not used by nft, use linux list native handling.

I think there is not need to cache the full nftnl_table object,
probably it should be even possible to just use it to collect the
attributes from the kernel to populate the nft_table object that I'm
proposing.

IIRC embedded people complained on the size of libnftnl, going this
direction I suggest, we can probably deprecated iterators for a number
of objects and get it slimmer in the midrun.

WDYT?
