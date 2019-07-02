Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA2C06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C202089C
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfGBSEe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 14:04:34 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44014 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGBSEe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 14:04:34 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hiN8q-0004GB-IM; Tue, 02 Jul 2019 20:04:32 +0200
Date:   Tue, 2 Jul 2019 20:04:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH RFC] nft: Set socket receive buffer
Message-ID: <20190702180432.GW31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190702151201.592-1-phil@nwl.cc>
 <20190702172615.t4lwms6zu4acq63e@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702172615.t4lwms6zu4acq63e@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 02, 2019 at 07:26:15PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 02, 2019 at 05:12:01PM +0200, Phil Sutter wrote:
> > When trying to delete user-defined chains in a large ruleset,
> > iptables-nft aborts with "No buffer space available". This can be
> > reproduced using the following script:
> > 
> > | #! /bin/bash
> > | iptables-nft-restore <(
> > |
> > | echo "*filter"
> > | for i in $(seq 0 200000);do
> > |         printf ":chain_%06x - [0:0]\n" $i
> > | done
> > | for i in $(seq 0 200000);do
> > |         printf -- "-A INPUT -j chain_%06x\n" $i
> > |         printf -- "-A INPUT -j chain_%06x\n" $i
> > | done
> > | echo COMMIT
> > |
> > | )
> > | iptables-nft -X
> > 
> > Note that calling 'iptables-nft -F' before the last call avoids the
> > issue. Also, correct behaviour is indicated by a different error
> > message, namely:
> > 
> > | iptables v1.8.3 (nf_tables):  CHAIN_USER_DEL failed (Device or resource busy): chain chain_000000
> > 
> > The used multiplier value is a result of trial-and-error, it is the
> > first one which eliminated the ENOBUFS condition.
> 
> This is triggering a lots of errors (ack messages) to userspace.
> 
> Could you estimate the buffer size based on the number of commands?
> 
> mnl_batch_talk() is called before iterating over the list of commands,
> so this number is already in place. Then, pass it to
> mnl_nft_socket_sendmsg().
> 
> I'd suggest you add a mnl_set_rcvbuffer() too. You could assume that
> getpagesize() is the maximum size for an acknoledgment.

Ah, I didn't get that kernel reply depends on number of commands sent,
not batch size. Thanks for your tip, this seems to work fine!

Thanks, Phil
