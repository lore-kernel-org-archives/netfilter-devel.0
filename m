Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6F7C55181
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 21:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B2C2078C
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 21:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgDTVF6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 17:05:58 -0400
Received: from correo.us.es ([193.147.175.20]:43722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgDTVF6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 17:05:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0FAA6120829
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 23:05:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0217EFA4F4
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 23:05:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EBD2252B60; Mon, 20 Apr 2020 23:05:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EECD6DA788;
        Mon, 20 Apr 2020 23:05:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 Apr 2020 23:05:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D089F42EF42A;
        Mon, 20 Apr 2020 23:05:54 +0200 (CEST)
Date:   Mon, 20 Apr 2020 23:05:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Bodong Wang <bodong@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org, ozsh@mellanox.com,
        paulb@mellanox.com
Subject: Re: [nf-next] netfilter: nf_conntrack, add IPS_HW_OFFLOAD status bit
Message-ID: <20200420210554.gpyvbfzojgzyzvqw@salvia>
References: <20200420145810.11035-1-bodong@mellanox.com>
 <20200420151525.qk764gfgydbip6u2@salvia>
 <b5f1eaca-a2c7-01f8-2d20-89762f435eaa@mellanox.com>
 <20200420153344.c2tjwmohirlnd4cj@salvia>
 <1ea59d48-c0d0-34fc-f443-eecb2ec3660e@mellanox.com>
 <20200420155828.yyo2wwkwnpav4dtp@salvia>
 <1641b7e5-6558-7184-496a-840af538d9ed@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641b7e5-6558-7184-496a-840af538d9ed@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 20, 2020 at 11:45:44AM -0500, Bodong Wang wrote:
> On 4/20/2020 10:58 AM, Pablo Neira Ayuso wrote:
> > On Mon, Apr 20, 2020 at 10:46:54AM -0500, Bodong Wang wrote:
> > > On 4/20/2020 10:33 AM, Pablo Neira Ayuso wrote:
> > > > On Mon, Apr 20, 2020 at 10:28:00AM -0500, Bodong Wang wrote:
> > > > > On 4/20/2020 10:15 AM, Pablo Neira Ayuso wrote:
> > > > > > On Mon, Apr 20, 2020 at 09:58:10AM -0500, Bodong Wang wrote:
> > > > > > [...]
> > > > > > > @@ -796,6 +799,16 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
> > > > > > >     				       FLOW_OFFLOAD_DIR_REPLY,
> > > > > > >     				       stats[1].pkts, stats[1].bytes);
> > > > > > >     	}
> > > > > > > +
> > > > > > > +	/* Clear HW_OFFLOAD immediately when lastused stopped updating, this can
> > > > > > > +	 * happen in two scenarios:
> > > > > > > +	 *
> > > > > > > +	 * 1. TC rule on a higher level device (e.g. vxlan) was offloaded, but
> > > > > > > +	 *    HW driver is unloaded.
> > > > > > > +	 * 2. One of the shared block driver is unloaded.
> > > > > > > +	 */
> > > > > > > +	if (!lastused)
> > > > > > > +		clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
> > > > > > >     }
> > > > > > Better inconditionally clear off the flag after the entry is removed
> > > > > > from hardware instead of relying on the lastused field?
> > > > > Functionality wise, it should work. Current way is more for containing the
> > > > > set/clear in the same domain, and no need to ask each vendor to take care of
> > > > > this bit.
> > > > No need to ask each vendor, what I mean is to deal with this from
> > > > flow_offload_work_del(), see attached patch.
> > > Oh, I see. That is already covered in my patch as below. Howerver,
> > > flow_offload_work_del will only be triggered after timeout expired(30sec).
> > > User will see incorrect CT state within this 30 seconds timeframe, which the
> > > clear_bit based on lastused can solve it.
> > For TCP fin/rst the removal from hardware occurs once once the
> > workqueue has a chance to run.
> > 
> > For UDP, or in case the TCP connection stalls or no packets are seeing
> > after 30 seconds, then the flow is removed from hardware after 30
> > seconds.
> > 
> > The IPS_HW_OFFLOAD_BIT flag should be cleaned up when the flow is
> > effectively removed from hardware.
> > 
> > Why do you want to clean it up earlier than that? With your approach,
> > the flag is cleared but the flow is still in hardware?
> 
> In normally cases(no driver unload, etc), it is imdediately removed by
> flow_offload_work_del. Requests to remove the HW flow are from netfilter
> layer to driver via block_cb->cb. We're well covered in such cases.
> 
> The lastused is more for conner cases such as: iperf is still running, but
> driver is unloaded. In such case, driver removed all HW flows without
> notifying netfilter.

The driver should invoke the flowtable garbage collector let it clean
up the entries before the driver is unloaded.

> Flow_offload_work_del will only be called once timeout expired, and
> the indication of HW_OFFLOAD is incorrect within the timeout period.
> Meanwhile, lastused stopped updating once driver unloading process
> destroied flow couters. So, relying on this field to clear the
> HW_OFFLOAD bit to cover such conner cases.

This corner case is interesting.

Could you submit this patch without the lastused trick? Then, we can
revisit how the driver invokes the garbage collector to deal with the
cleanup?

All this model is based on the garbage collector being the one that is
responsible to cleaning up the flowtable. If there are multiple entry
points to add/remove entries to the flowtable, we'll end up with
complicated locking sooner or later.

Thanks.
