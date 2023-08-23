Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D389DEE49A0
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 10:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbjHWK1Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 06:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjHWK1Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 06:27:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE03124
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 03:27:21 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qYl54-00037H-S3; Wed, 23 Aug 2023 12:27:18 +0200
Date:   Wed, 23 Aug 2023 12:27:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Turritopsis Dohrnii Teo En Ming <tdtemccnp@gmail.com>,
        cluster-devel.redhat.com@debian.me,
        Linux Netfilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Cluster-devel] I have been given the guide with full network
 diagram on configuring High Availability (HA) Cluster and SD-WAN for
 Fortigate firewalls by my boss on 10 May 2023 Wed
Message-ID: <ZOXfBivIvWHkprB0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Turritopsis Dohrnii Teo En Ming <tdtemccnp@gmail.com>,
        cluster-devel.redhat.com@debian.me,
        Linux Netfilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <CAD3upLsRxrvG0GAcFZj+BfAb6jbwd-vc2170sZHguWu4mRJpog@mail.gmail.com>
 <ZONwlkirjv2iBFiA@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZONwlkirjv2iBFiA@debian.me>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ Dropped lkml and netdev lists.]

On Mon, Aug 21, 2023 at 09:11:34PM +0700, Bagas Sanjaya wrote:
> On Wed, May 10, 2023 at 11:12:26PM +0800, Turritopsis Dohrnii Teo En Ming wrote:
> > Good day from Singapore,
> > 
> > I have been given the guide with full network diagram on configuring
> > High Availability (HA) Cluster and SD-WAN for Fortigate firewalls by
> > my boss on 10 May 2023 Wed. This involves 2 ISPs, 2 identical
> > Fortigate firewalls and 3 network switches.
> > 
> > Reference guide: SD-WAN with FGCP HA
> > Link: https://docs.fortinet.com/document/fortigate/6.2.14/cookbook/23145/sd-wan-with-fgcp-ha
> > 
> > I have managed to deploy HA cluster and SD-WAN for a nursing home at
> > Serangoon Singapore on 9 May 2023 Tue, with some minor hiccups. The
> > hiccup is due to M1 ISP ONT not accepting connections from 2 Fortigate
> > firewalls. Singtel ISP ONT accepts connections from 2 Fortigate
> > firewalls without any problems though. On 9 May 2023 Tue, I was
> > following the network diagram drawn by my team leader KKK. My team
> > leader KKK's network diagram matches the network diagram in Fortinet's
> > guide shown in the link above.
> > 
> > The nursing home purchased the following network equipment:
> > 
> > [1] 2 units of Fortigate 101F firewalls with firmware upgraded to version 7.2.4
> > 
> > [2] 3 units of Aruba Instant On 1830 8-port network switches
> > 
> > [3] Multiple 5-meter LAN cables
> > 
> 
> Then why did you post Fortigate stuffs here in LKML when these are (obviously)
> off-topic? Why don't you try netfilter instead? And do you have any
> kernel-related problems?

I am not familiar with fortinet products, but the above neither mentions
"kernel", nor "netfilter" or even "linux". There's no evidence either of
the addressed kernel mailing lists should be concerned. I suggest to
contact fortinet support instead.

> Confused...

BtW: Adding yet another unrelated mailing list to Cc is just making
things worse.

Cheers, Phil
