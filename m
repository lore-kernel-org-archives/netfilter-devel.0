Return-Path: <SRS0=YYk6=R7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61229C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 19:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21F7B2054F
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 19:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="WDhJtHEi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfC1T7B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Mar 2019 15:59:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44371 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfC1T7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Mar 2019 15:59:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id w5so24579559qtb.11
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Mar 2019 12:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=A1lLK5CpRCcw/UFI8ITUPaLqgF6qi0thGTWwSURJUUw=;
        b=WDhJtHEiRPXDaosmxOK3lNrF/Ow86ugy+z7MJRvay1NN6qxwhc3IOy0gS6GCDtVASQ
         7ZSpmv2+Talop50LxwRFHBqRYaQOn7Pdbu5e8CGF0i2L6345JnbCQxvZiZL//s9UYtqz
         4E0rrV4sfAeq/Jln2YzZ5YRr7umaq0AxlSgYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=A1lLK5CpRCcw/UFI8ITUPaLqgF6qi0thGTWwSURJUUw=;
        b=OpbrhnZOQ2gT1xjwoURYHpHFjPOJ0ZVPpFv0+PMmGOAMoVs31MZin4tr8RADe7tCQX
         lZvSVAK/qqUNq2CJGQSi2oCWs+eo/Cl4Tt3i1Tv4rE8mBIpW/RmDgdU1TRiYJM8GicZx
         hm+SdalpAOgB0pz+u8QQauvRWaYpnyffvSzv1mKI0r+oWQY/js1urr4kpNOfbQThNfIY
         +r6PsjeR2MPbQMy3lSsRx2dKxsmOghxwyMmCvJpiA5a2T2VfPqwd5rlVrNEsIfpfjA5e
         xK8ZV0kQNrmAXdBK3O8nxynEimkeBt6pVU+zZ7JIK2GS9PgX/9M0sSykXP114qbREeFv
         Jz4Q==
X-Gm-Message-State: APjAAAUSEQHcFCbJ9DH3Ay8HN6F2oG6/8I4UsrkWL7QsadHX1tnCvhxg
        MBoo8TjE5Vi7Vsp4dTzzGmON4uTjH1s=
X-Google-Smtp-Source: APXvYqzFSdYBAqxL4A92YxC1DreOXnIrL8ivJMQEv+3O4w56zO5xwSzrpRqmgDS6xGl4NW8onjB3sQ==
X-Received: by 2002:aed:3c0f:: with SMTP id t15mr17960358qte.282.1553803140098;
        Thu, 28 Mar 2019 12:59:00 -0700 (PDT)
Received: from pinebook (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id y197sm6379319qkb.23.2019.03.28.12.58.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Mar 2019 12:58:59 -0700 (PDT)
Date:   Thu, 28 Mar 2019 15:58:57 -0400
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Cc:     dmorris@untangle.com
Subject: dict: A netfilter expression for dictionary lookups
Message-ID: <20190328195857.GA24011@pinebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

My name is Brett Mastbergen.  My colleage Dirk Morris and I have been
working on some nftables functionality that we think is kind of cool so we
figured we'd post it to the list to see if anyone had any thoughts or
feedback on what we are doing.

Below is the summary of nft_dict from our documentation which can be found 
here:
https://github.com/untangle/nft_dict/blob/master/docs/dict.rst

The nft_dict, short for netfilter dictionary, module provides a nft rule 
mechanism do table lookups on environment metadata that is not present in the 
packet and not contained within the rule. In a firewall you often wish to 
block or manipulate packets based on things not immediately evident in the
packet, but things that can often be calculated via other mechanisms.

nft_dict provides the ability to create dictionaries (lookup tables) stored 
within kernel space for fast lookups. These tables can be maintained by 
userspace applications where it is more convenient to calculate various 
network metadata. In our case, we have a userspace daemon (packetd) which
listens to various packets with nfqueue and builds various dictionaries of
metadata based on the traffic it sees and the information it gathers.

nft_dict is a kernel module providing the kernel support for the "dict" 
expression.  Its source can be found at the link below:

https://github.com/untangle/nft_dict

Additionally, userspace patches are required in order to use the 
"dict" expression from within an nft rule. These currently live here:

https://github.com/untangle/mfw_openwrt/blob/openwrt-18.06/libnftnl/patches/999-libnftnl-Add-dict-support.patch 
https://github.com/untangle/mfw_openwrt/blob/openwrt-18.06/nftables/patches/999-nftables-Add-dict.patch

These patches, along with the nft_dict kernel module, also add support for an 
"id" key to the "ct" match expression. The "ct id" expression simply returns 
the conntrack id of the conntrack. This is the same conntrack id you see if 
you run 'conntrack -L --output=id'. While not strictly required, the "ct id" 
expression is extremely useful as a key expression into a dict table for 
matching entries to a particular conntrack. The correct place to implement 
the "id" ct key is in the existing nft_ct module, but for now its implemented
in the nft_dict module.

For a more in depth description of how things work I suggest reading the doc 
in the first link I posted, but below are a few simple examples of what is 
possible using dict expressions:

nft add rule ip filter forward dict sessions ct id application long_string 
NETFLIX reject 

If I were to describe that rule in plain English it would be:

For traffic passing through the ip filter table forward hook, use the 
conntrack id as a key to lookup an entry in the sessions table.  For that
entry check if it has an application field set to a string value of NETFLIX,
if so, reject the traffic.

How did that field get set to NETFLIX?  That is up to some other entity.  In 
our case it is a userspace daemon that is inspecting traffic via nfqueue.
All of the metadata generated for the stream of traffic can be written into
the sessions table such that these dict rules can act upon it.  The userspace
daemon doesn't make determinations about how traffic should be acted upon
(accept, reject, drop, route, count, etc), it just populates the information
in the table to let the nft rules act upon the traffic.  This means the
userspace daemon only has to listen to traffic of a particular stream for as
long as it needs to determine all of the target metadata.  That particular
traffic stream can then bypass the nfqueue hook but can continue to be acted
upon using the information in the sessions table.

Here is another example:

nft add rule ip filter forward tcp dport 80 dict hosts ip saddr \
captive-portal-authenticated bool false dnat to 127.0.0.1:80

Here we are using the packet source ip address as the key into a hosts table
that (among other things) lets us know if this host has been authenticated via
captive portal.  If it hasn't, we send its web traffic to the local webserver.

The next example uses a dict expresssion as the key to another dict expression:

nft add rule ip filter forward dict users dict sessions ct id username \
long_string quota-exceeded bool true reject

This rule uses the conntrack id to look up the username associated with the
session, and then uses that username as the key into the users table so it
can check if this user has exceeded its quota.

If any of that sounds interesting, have a look at the code and docs.  Let us
know if you have questions or thoughts.

Thanks,
Brett

