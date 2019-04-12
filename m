Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBE0C10F0E
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 14:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF7D620850
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 14:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="VCFa9gIA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfDLOSj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 10:18:39 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40775 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfDLOSj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 10:18:39 -0400
Received: by mail-qt1-f196.google.com with SMTP id x12so11364733qts.7
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2019 07:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kv6x2wC0lAUmMQBptjH7DGQHmUI4nhB4/E5uK5HZT4k=;
        b=VCFa9gIAbgOqjedaCoRDOaL5DqAkm/SqFWVxTOD2eEvFR8KsQcg21h5vDkKOBLYVR3
         GUvTWlpYC5jsvS5GT6ePJMIVJXuzkarPBZVYen+mGN7T291FfcybVvaYPHdPdtxf5UT3
         D4fepeWH730uciuFwbws+S8Odm23LytWIS8Qc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kv6x2wC0lAUmMQBptjH7DGQHmUI4nhB4/E5uK5HZT4k=;
        b=HLcd15qmmmWseVrKOT4cNkQgqQ2c0W316iZgOYji9FUSKlFL/1AWAdQb15+5qy5KUy
         HT0VkBlKLqzhetXzhKDqYVA+4OdwwZx2fiVAr2ofM31xFPmiYUCx33FquCewBPkVao3t
         C1gPkbMxqX5eK+KQdNP7RAw5AMpYSOJ5u5Qt7AzLRuaCpoTNiCBSMmHdXfCHwGtk00rE
         wPpXqDFJapNXeLRxTJQsRQaKj1Nziv4q+YBgNL6V3xGKPu+Bb/tGkxx6aaG+Go73JbS1
         KRQiOt142/WGNmnnHAur8MuC44pXBn8JzOAUtDgJ/qq4gBB6aGZlx5AVkdck9BiVBfKD
         e8zg==
X-Gm-Message-State: APjAAAWVbul2V399wCJ5VqTkMvE9KBK5C9Cu7faYkXBI/0rxgoXBC7p2
        eWavn76dGKo5sMZsGnrWfMXzckL6Qf8=
X-Google-Smtp-Source: APXvYqxVb/nXF8oJB3BWFCracGgxDnIgj2/TX5P744ku3wI63sBtvNN62C2OSUnwJE/FP96gZon98g==
X-Received: by 2002:a0c:a322:: with SMTP id u31mr43043611qvu.207.1555078718156;
        Fri, 12 Apr 2019 07:18:38 -0700 (PDT)
Received: from pinebook (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id g189sm8471367qkd.60.2019.04.12.07.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 07:18:37 -0700 (PDT)
Date:   Fri, 12 Apr 2019 10:18:34 -0400
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, dmorris@untangle.com
Subject: Re: dict: A netfilter expression for dictionary lookups
Message-ID: <20190412141834.GA25271@pinebook>
References: <20190328195857.GA24011@pinebook>
 <20190411192248.7harez523hlkhh3e@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411192248.7harez523hlkhh3e@breakpoint.cc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 11-04-19, Florian Westphal wrote:
> Brett Mastbergen <bmastbergen@untangle.com> wrote:
> > My name is Brett Mastbergen.  My colleage Dirk Morris and I have been
> > working on some nftables functionality that we think is kind of cool so we
> > figured we'd post it to the list to see if anyone had any thoughts or
> > feedback on what we are doing.
> > 
> > Below is the summary of nft_dict from our documentation which can be found 
> > here:
> > https://github.com/untangle/nft_dict/blob/master/docs/dict.rst
> > 
> > The nft_dict, short for netfilter dictionary, module provides a nft rule 
> > mechanism do table lookups on environment metadata that is not present in the 
> > packet and not contained within the rule. In a firewall you often wish to 
> > block or manipulate packets based on things not immediately evident in the
> > packet, but things that can often be calculated via other mechanisms.
> >
> > nft_dict provides the ability to create dictionaries (lookup tables) stored 
> > within kernel space for fast lookups. These tables can be maintained by 
> > userspace applications where it is more convenient to calculate various 
> > network metadata. In our case, we have a userspace daemon (packetd) which
> > listens to various packets with nfqueue and builds various dictionaries of
> > metadata based on the traffic it sees and the information it gathers.
> > 
> > nft_dict is a kernel module providing the kernel support for the "dict" 
> > expression.  Its source can be found at the link below:
> > 
> > https://github.com/untangle/nft_dict
> > 
> > Additionally, userspace patches are required in order to use the 
> > "dict" expression from within an nft rule. These currently live here:
> > 
> > https://github.com/untangle/mfw_openwrt/blob/openwrt-18.06/libnftnl/patches/999-libnftnl-Add-dict-support.patch 
> > https://github.com/untangle/mfw_openwrt/blob/openwrt-18.06/nftables/patches/999-nftables-Add-dict.patch
> > 
> > These patches, along with the nft_dict kernel module, also add support for an 
> > "id" key to the "ct" match expression. The "ct id" expression simply returns 
> > the conntrack id of the conntrack. This is the same conntrack id you see if 
> > you run 'conntrack -L --output=id'. While not strictly required, the "ct id" 
> > expression is extremely useful as a key expression into a dict table for 
> > matching entries to a particular conntrack.
> 
> > The correct place to implement
> > the "id" ct key is in the existing nft_ct module, but for now its implemented
> > in the nft_dict module.
> 
> I would welcome adding support for this to nft_ct.c directly (i.e., get
> support for a unique per-ct id) once this patch is accepted:
> 
>  https://patchwork.ozlabs.org/patch/1072650/
> 
> I added nf_ct_get_id() to the conntrack core so it can be called from
> nft_ct later on.

This patch looks great.  That would greatly improve the usefulness of keying
off of the conntrack id.  If it gets accepted I can send a kernel patch and
an nft patch to support the ct id key.
> 
> > For a more in depth description of how things work I suggest reading the doc 
> > in the first link I posted, but below are a few simple examples of what is 
> > possible using dict expressions:
> > 
> > nft add rule ip filter forward dict sessions ct id application long_string 
> > NETFLIX reject 
> > 
> > If I were to describe that rule in plain English it would be:
> > 
> > For traffic passing through the ip filter table forward hook, use the 
> > conntrack id as a key to lookup an entry in the sessions table.  For that
> > entry check if it has an application field set to a string value of NETFLIX,
> > if so, reject the traffic.
> > 
> > How did that field get set to NETFLIX?  That is up to some other entity.  In 
> 
> Why isn't it possible to use the existing nftables set infrastructure
> for this?
> 
> The nft sets store arbitrary octets/bytes as keys, so we could at least
> from kernel side store arbitrary identifiers (strings, integers etc).
> 

I wanted to use the existing set infrastructure, but I ran into two issues
wrt to what we were trying to acheive:

1.  As far as I can tell the current sets are only set up to hold elements
of a particular data type, where as we are storing elements of many different
types in a particular dictionary.

2.  sets are associated with a particular table and therefore can only be
accessed by rules in that table.  If you want to associate some piece of
information with a particular connection and use it from rules in multiple
different tables, you'd have to populate it in a set in each of those tables.
While thats certainly doable, the dictionaries we create are "global", that
is, rules from any table can access them and entries can be added and removed
from a single place.

> > nft add rule ip filter forward tcp dport 80 dict hosts ip saddr \
> > captive-portal-authenticated bool false dnat to 127.0.0.1:80
> 
> nft supports something like
> 
> nft add rule ip filter forward tcp dport 80 ip saddr != @captive_authenticated ...
> 
> and allows external entity to push ip addresses to the set
> @captive_authenticated.

For sure, sets can do that.  That maybe isn't the best example of the dict's
usefulness. :)
> 
> I'll have a look at doc and code later today.

Cool.  I really appreciate you taking the time.
