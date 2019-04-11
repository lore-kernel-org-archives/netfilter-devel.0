Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A5CC10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 19:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D27342083E
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 19:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfDKTWv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 15:22:51 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37534 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726577AbfDKTWv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 15:22:51 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hEfHc-0003Th-H3; Thu, 11 Apr 2019 21:22:48 +0200
Date:   Thu, 11 Apr 2019 21:22:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Brett Mastbergen <bmastbergen@untangle.com>
Cc:     netfilter-devel@vger.kernel.org, dmorris@untangle.com
Subject: Re: dict: A netfilter expression for dictionary lookups
Message-ID: <20190411192248.7harez523hlkhh3e@breakpoint.cc>
References: <20190328195857.GA24011@pinebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328195857.GA24011@pinebook>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Brett Mastbergen <bmastbergen@untangle.com> wrote:
> My name is Brett Mastbergen.  My colleage Dirk Morris and I have been
> working on some nftables functionality that we think is kind of cool so we
> figured we'd post it to the list to see if anyone had any thoughts or
> feedback on what we are doing.
> 
> Below is the summary of nft_dict from our documentation which can be found 
> here:
> https://github.com/untangle/nft_dict/blob/master/docs/dict.rst
> 
> The nft_dict, short for netfilter dictionary, module provides a nft rule 
> mechanism do table lookups on environment metadata that is not present in the 
> packet and not contained within the rule. In a firewall you often wish to 
> block or manipulate packets based on things not immediately evident in the
> packet, but things that can often be calculated via other mechanisms.
>
> nft_dict provides the ability to create dictionaries (lookup tables) stored 
> within kernel space for fast lookups. These tables can be maintained by 
> userspace applications where it is more convenient to calculate various 
> network metadata. In our case, we have a userspace daemon (packetd) which
> listens to various packets with nfqueue and builds various dictionaries of
> metadata based on the traffic it sees and the information it gathers.
> 
> nft_dict is a kernel module providing the kernel support for the "dict" 
> expression.  Its source can be found at the link below:
> 
> https://github.com/untangle/nft_dict
> 
> Additionally, userspace patches are required in order to use the 
> "dict" expression from within an nft rule. These currently live here:
> 
> https://github.com/untangle/mfw_openwrt/blob/openwrt-18.06/libnftnl/patches/999-libnftnl-Add-dict-support.patch 
> https://github.com/untangle/mfw_openwrt/blob/openwrt-18.06/nftables/patches/999-nftables-Add-dict.patch
> 
> These patches, along with the nft_dict kernel module, also add support for an 
> "id" key to the "ct" match expression. The "ct id" expression simply returns 
> the conntrack id of the conntrack. This is the same conntrack id you see if 
> you run 'conntrack -L --output=id'. While not strictly required, the "ct id" 
> expression is extremely useful as a key expression into a dict table for 
> matching entries to a particular conntrack.

> The correct place to implement
> the "id" ct key is in the existing nft_ct module, but for now its implemented
> in the nft_dict module.

I would welcome adding support for this to nft_ct.c directly (i.e., get
support for a unique per-ct id) once this patch is accepted:

 https://patchwork.ozlabs.org/patch/1072650/

I added nf_ct_get_id() to the conntrack core so it can be called from
nft_ct later on.

> For a more in depth description of how things work I suggest reading the doc 
> in the first link I posted, but below are a few simple examples of what is 
> possible using dict expressions:
> 
> nft add rule ip filter forward dict sessions ct id application long_string 
> NETFLIX reject 
> 
> If I were to describe that rule in plain English it would be:
> 
> For traffic passing through the ip filter table forward hook, use the 
> conntrack id as a key to lookup an entry in the sessions table.  For that
> entry check if it has an application field set to a string value of NETFLIX,
> if so, reject the traffic.
> 
> How did that field get set to NETFLIX?  That is up to some other entity.  In 

Why isn't it possible to use the existing nftables set infrastructure
for this?

The nft sets store arbitrary octets/bytes as keys, so we could at least
from kernel side store arbitrary identifiers (strings, integers etc).

> nft add rule ip filter forward tcp dport 80 dict hosts ip saddr \
> captive-portal-authenticated bool false dnat to 127.0.0.1:80

nft supports something like

nft add rule ip filter forward tcp dport 80 ip saddr != @captive_authenticated ...

and allows external entity to push ip addresses to the set
@captive_authenticated.

I'll have a look at doc and code later today.
