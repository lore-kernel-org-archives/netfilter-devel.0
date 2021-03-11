Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5082DC433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2289264FC5
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhCKACn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:02:43 -0500
Received: from correo.us.es ([193.147.175.20]:46722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229815AbhCKACX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 19:02:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87C2912E82B
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 01:02:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70338DA72F
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 01:02:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64C74DA730; Thu, 11 Mar 2021 01:02:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5698DA72F;
        Thu, 11 Mar 2021 01:02:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:02:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B6D8F42DC6E2;
        Thu, 11 Mar 2021 01:02:12 +0100 (CET)
Date:   Thu, 11 Mar 2021 01:02:12 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marc =?utf-8?Q?Aur=C3=A8le?= La France <tsi@tuyoix.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter REJECT: Fix destination MAC in RST packets
Message-ID: <20210311000212.GA21480@salvia>
References: <alpine.LNX.2.20.2103071736460.15162@fanir.tuyoix.net>
 <20210308102510.GA23497@salvia>
 <alpine.WNT.2.20.2103080908550.2772@CLUIJ>
 <20210309013621.GA27206@salvia>
 <alpine.WNT.2.20.2103082114130.1604@CLUIJ>
 <20210309102740.GA30899@salvia>
 <alpine.WNT.2.20.2103101640090.3708@CLUIJ>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.WNT.2.20.2103101640090.3708@CLUIJ>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 10, 2021 at 04:51:26PM -0700, Marc Aurèle La France wrote:
> On Tue, 9 Mar 2021, Pablo Neira Ayuso wrote:
> > On Mon, Mar 08, 2021 at 09:25:28PM -0700, Marc Aurèle La France wrote:
> > > On Tue, 9 Mar 2021, Pablo Neira Ayuso wrote:
> > > > On Mon, Mar 08, 2021 at 09:21:20AM -0700, Marc Aurèle La France wrote:
> > > > > On Mon, 8 Mar 2021, Pablo Neira Ayuso wrote:
> > > > > > On Sun, Mar 07, 2021 at 06:16:34PM -0700, Marc Aurèle La France wrote:
> 
> > > > > > > In the non-bridge case, the REJECT target code assumes the REJECTed
> > > > > > > packets were originally emitted by the local host, but that's not
> > > > > > > necessarily true when the local host is the default route of a subnet
> > > > > > > it is on, resulting in RST packets being sent out with an incorrect
> > > > > > > destination MAC.  Address this by refactoring the handling of bridged
> > > > > > > packets which deals with a similar issue.  Modulo patch fuzz, the
> > > > > > > following applies to v5 and later kernels.
> 
> > > > > > The code this patch updates is related to BRIDGE_NETFILTER. Your patch
> > > > > > description refers to the non-bridge case. What are you trying to
> > > > > > achieve?
> 
> > > > > Via DHCP, my subnet's default route is a Linux system so that it can monitor
> > > > > all outbound traffic.  By doing so, for example, I have determined that my
> > > > > Android phone connects to Facebook despite the fact that I have no such app
> > > > > installed.  I want to know, and control, what other behind-the-scenes
> > > > > (under-handed) traffic devices on my subnet generate.
> 
> > > > > > dev_queue_xmit() path should not be exercised from the prerouting
> > > > > > chain, packets generated from the IP later must follow the
> > > > > > ip_local_out() path.
> 
> > > > > Well, I can tell you dev_queue_xmit() does in fact work in prerouting
> > > > > chains, as it must for the bridging case.  The only potential problem I've
> > > > > found so far is that the RST packet doesn't go through any netfilter hooks.
> 
> > > > That's the issue, Netfilter rejects code from the IP layer, so the
> > > > packets follows the ip_local_out() path.
> 
> > > ... which sets an incorrect destination MAC.  Also, in this case, netfilter
> > > doesn't reject any such thing.  It doesn't even "see" the RST packet
> > > dev_queue_xmit() sends out.  That's OK as there is no further need to
> > > process such a packet.
> 
> > dev_queue_xmit() skips the policy in the local out path for the
> > generated RST packet. If you want to plain reject using
> > dev_queue_xmit() then you have to use the ingress hook.
> 
> > > At least, the device whose connection request is being denied
> > > doesn't hang anymore...
> 
> > The neighbour cache selects the destination MAC from the destination
> > IP address of the RST packet.
> 
> > Your patch also refers to non-bridge scenario (no br_netfilter in
> > place).
> 
> > Could you describe what you're trying to achieve in plain layman terms?
> 
> I will (re-)do no such thing because you are refusing to make sense.
> 
> It's OK that the bridge code uses dev_queue_xmit() to send out an RST packet
> that has correct MACs, but that doesn't make another trip through netfilter.

It's not OK that the bridge uses dev_queue_xmit().

That was an ugly solution to make the REJECT target work from
br_netfilter, because there was absolutely no other better way at that
time to make it work.

There has been now native support to reject traffic from the bridge
from many years on through br_forward(), which is the way to go.

If you want to reject from a non-bridge setup, there is also ingress
support where you can reject exactly in the way you want, way earlier
than from prerouting.
