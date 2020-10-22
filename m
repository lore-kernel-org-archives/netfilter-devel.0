Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C96C388F2
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 12:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F7222267
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 12:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898265AbgJVMgx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 08:36:53 -0400
Received: from correo.us.es ([193.147.175.20]:38410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898263AbgJVMgx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 08:36:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B7CE4A706D
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 14:36:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89BE8DA78B
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 14:36:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7F581DA789; Thu, 22 Oct 2020 14:36:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34455DA78D;
        Thu, 22 Oct 2020 14:36:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 14:36:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1444042EE393;
        Thu, 22 Oct 2020 14:36:48 +0200 (CEST)
Date:   Thu, 22 Oct 2020 14:36:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 6/8] conntrack: implement options output format
Message-ID: <20201022123647.GA15948@salvia>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
 <20200925124919.9389-7-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200925124919.9389-7-mikhail.sennikovskii@cloud.ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mikhail,

Thanks for your patchset.

On Fri, Sep 25, 2020 at 02:49:17PM +0200, Mikhail Sennikovsky wrote:
> As a counterpart to the "conntrack: accept parameters from stdin"
> commit, this commit allows dumping conntrack entries in the format
> used by the conntrack parameters.
> This is useful for transfering a large set of ct entries between
> hosts or between different ct zones in an efficient way.
> 
> To enable the "options" output the "-o opts" parameter needs to be
> passed to the "contnrack -L" tool invocation.

I started slightly revisiting this 6/8 patch a bit (please find it
enclosed to this email), I have rename -o opts to -o save, to get this
aligned with iptables-save.

I have also added a check for -o xml,save , to reject this
combination.

I have extended it to display -I, -U, -D in the conntrack events.

I have removed several safety runtime checks, that can be done at
registration time (make sure the option description is well-formed
from there, otherwise rise an error message to spot buggy protocol
extensions).

This patch should also be extended to support for other existing
output flags combinations. Or just bail out if they are specified.

At this point I have concerns with NAT: I don't see how this can work
as is. There is also a conntrack helpers that might trigger NAT
sequence adjustments, this information would be lost.

We would need to expose all these details through the -o save, see
below. For some of this, there is no options from command line,
because it made no sense to expose them.

We have to discuss this before deciding where to go. See below for
details.

> To demonstrate the overall idea of the options output format works
> in conjunction with the "stdin parameter"s mode,
> the following command will copy all ct entries from one ct zone
> to another.
> 
> conntrack -L -w 15 -o opts | sed 's/-w 15/-w 9915/g' | conntrack -I -

For zone updates in the same host, probably conntrack can be extended
to support for:

        conntrack -U --zone 15 --set-zone 9915

If --set-zone is specified, then --zone is used a filter.

Then, for "zone transfers" *between hosts*, a different way to address
this is to extend conntrackd.

The idea is:

1) Add new "transfer" mode which does _not_ subscribe to
   conntrack events, it needs to register a new struct ct_mode
   (currently there is "sync" and "stats" ct_modes).

2) Add a new message type to request a zone transfer, e.g.

        conntrackd --from 192.168.10.20 --zone 15 --set-zone 9915

   This will make your local daemon send a request to the conntrackd
   instance running on host 192.168.10.20 to retrieve zone 1200. The
   remote conntrackd instance dumps the existing conntrack table from
   kernel and sends it to you.

   You can reuse the channel infrastructure to establish communications
   between conntrackd instances in the new "transfer mode". You can
   also reuse the sync protocol, see network.h, build.c and parse.c,
   which takes a conntrack object and it translates it to network
   message.

   Note that the struct internal_handler actually refers to the
   netlink handler for this new struct ct_mode that you would be
   registering.

Let me know, thanks.
