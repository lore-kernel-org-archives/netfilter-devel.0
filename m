Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB4AC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 12:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiATMkP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:40:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38690 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiATMkO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 07:40:14 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 133AA6006E;
        Thu, 20 Jan 2022 13:37:15 +0100 (CET)
Date:   Thu, 20 Jan 2022 13:40:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YelYKewDL7UkeQZf@salvia>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
 <YejdVZaoUz+t1qRU@slk1.local.net>
 <20220120120458.GF31905@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220120120458.GF31905@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 20, 2022 at 01:04:58PM +0100, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
> > >
> > > This patch have a number of showstoppers such as exposing structure
> > > layout on the header files.
> > >
> > That's only in patch 5. You could apply 1-4. There are actually no other
> > showstoppers, right?
> 
> Regarding patch 5, I think its ok except the pkt_buff layout freeze.
> 
> From a quick glance, there is no assumption that the data area resides
> after the pktbuff head, so it should be possible to keep pkt_buff
> private, allocate an empty packet and then associate a new buffer with
> it.

Or allocate pktbuff offline and recycle it (re-setup) on new packets
coming from the kernel, it does not need to be allocated in the
stack and exposing the layout is also therefore not requireed.
