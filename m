Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F459C54EBD
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 11:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjALL5v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 06:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbjALL5N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 06:57:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCF8813F29
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 03:50:13 -0800 (PST)
Date:   Thu, 12 Jan 2023 12:50:10 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
Message-ID: <Y7/z8iZqvfDIuac9@salvia>
References: <20230104113143.21769-1-sriram.yagnaraman@est.tech>
 <Y7WVAEky9Iy3Ri3T@salvia>
 <DBBP189MB1433F79520D32E1CB0F8A62A95FA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
 <Y7a6VqqMmW191RIG@salvia>
 <DBBP189MB14337144265DA856B8321D1695FA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
 <Y7dwTU9Ky6RN1u7L@salvia>
 <DBBP189MB1433F9BBBF659878DDEB6B1495FC9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DBBP189MB1433F9BBBF659878DDEB6B1495FC9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 11, 2023 at 09:36:38AM +0000, Sriram Yagnaraman wrote:
> > -----Original Message-----
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > Sent: Friday, 6 January 2023 01:50
> > To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > Cc: netfilter-devel@vger.kernel.org; Florian Westphal <fw@strlen.de>;
> > Marcelo Ricardo Leitner <mleitner@redhat.com>; Long Xin
> > <lxin@redhat.com>; Claudio Porfiri <claudio.porfiri@ericsson.com>
> > Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
> > 
> > On Thu, Jan 05, 2023 at 12:11:44PM +0000, Sriram Yagnaraman wrote:
> > > > -----Original Message-----
> > > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > Sent: Thursday, 5 January 2023 12:54
> > > > To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > > > Cc: netfilter-devel@vger.kernel.org; Florian Westphal
> > > > <fw@strlen.de>; Marcelo Ricardo Leitner <mleitner@redhat.com>; Long
> > > > Xin <lxin@redhat.com>; Claudio Porfiri
> > > > <claudio.porfiri@ericsson.com>
> > > > Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp state
> > > > machine
> > > >
> > > > On Thu, Jan 05, 2023 at 11:41:13AM +0000, Sriram Yagnaraman wrote:
> > > > > > -----Original Message-----
> > > > > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > > Sent: Wednesday, 4 January 2023 16:02
> > > > > > To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > > > > > Cc: netfilter-devel@vger.kernel.org; Florian Westphal
> > > > > > <fw@strlen.de>; Marcelo Ricardo Leitner <mleitner@redhat.com>;
> > > > > > Long Xin <lxin@redhat.com>
> > > > > > Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp
> > > > > > state machine
> > > > > >
> > > > > > On Wed, Jan 04, 2023 at 12:31:43PM +0100, Sriram Yagnaraman
> > wrote:
> > > > > > > All the paths in an SCTP connection are kept alive either by
> > > > > > > actual DATA/SACK running through the connection or by HEARTBEAT.
> > > > > > > This patch proposes a simple state machine with only two
> > > > > > > states OPEN_WAIT and ESTABLISHED (similar to UDP). The reason
> > > > > > > for this change is a full stateful approach to SCTP is
> > > > > > > difficult when the association is multihomed since the
> > > > > > > endpoints could use different paths in the network during the lifetime
> > of an association.
> > > > > >
> > > > > > Do you mean the router/firewall might not see all packets for
> > > > > > association is multihomed?
> > > > > >
> > > > > > Could you please provide an example?
> > > > >
> > > > > Let's say the primary and alternate/secondary paths between the
> > > > > SCTP endpoints traverse different middle boxes. If an SCTP
> > > > > endpoint detects network failure on the primary path, it will
> > > > > switch to using the secondary path and all subsequent packets will
> > > > > not be seen by the middlebox on the primary path, including
> > > > > SHUTDOWN sequences if they happen at that time.
> > > >
> > > > OK, then on the primary middle box the SCTP flow will just timeout?
> > > > (because no more packets are seen).
> > >
> > > Yes, they will timeout unless the primary path comes up before the
> > > SHUTDOWN sequence. And the default timeout for an ESTABLISHED SCTP
> > > connection is 5 days, which is a "long" time to clean-up this entry.
> > 
> > Does the middle box have a chance to see any packet that provides a hint to
> > shorten this timeout? no HEARTBEAT packets are seen in this case on the
> > former primary path?
> 
> There will be HEARTBEAT as soon as a path becomes unreachable from
> the SCTP endpoints. But depending on the location of the network
> failure, the middlebox may or may not see the HEARTBEAT.

Conntrack assumes you have see all traffic that belongs the flow for
other protocols too.

> Also, HEARTBEAT is sent when there are no data to be transmitted or
> if the path is unreachable/unconfirmed, so I think there is no
> deterministic way of finding out when to shorten the timeout. Of
> course, a user has the option of setting the ESTABLISHED state
> timeout to a more reasonable value, for e.g., same as the
> HEARTBEAT_ACKED state timeout (210 sec), OR we could reduce the
> default timeout of ESTABLISHED to 210 sec.

Then just set up a short ESTABLISHED when multihoming is in place
since the beginning.

> > What I am missing are a more detailed list of issues with the existing
> > approach. Your patch description says "SCTP tracking with multihoming is
> > difficult", probably a list of scenarios would help to understand the motivation
> > to simplify the state machine.
> 
> Thank you for reviewing and asking these questions, it made me step back and think. I list below some background
> - I want to simplify the state machine, because it is possible to
> track an SCTP connection with fewer states, for e.g., SCTP with UDP
> encapsulation uses UDP conntrack with just UNREPLIED/REPLIED states
> and it works perfectly fine

I think it would preferrable to add some configuration via ruleset to
track SCTP over UDP, rather than deranking SCTP to become almost
stateless.

> - My stakeholders, at the behest of whom I am proposing these
> changes hit some problems running SCTP client endpoints behind NAT
> (inside Kubernetes pods) towards multihomed SCTP server endpoints
> (1a-g) and (2a-c) below
> - Some upcoming SCTP protocol changes in IETF (if
> approved/implemented) will make it hard to read beyond the SCTP
> common header, for e.g., DTLS over SCTP
> https://datatracker.ietf.org/doc/draft-ietf-tsvwg-dtls-over-sctp-bis/,
> proposes to encrypt all SCTP chunks, conntrack will only be able to
> see SCTP common header, these changes hopefully will make it easier
> to adapt to such changes in SCTP protocol - While at it, I also made
> some other "improvements"

For this DTLS case it should be possible to fall back to the SCTP
"stateless" approach.

> 	a) Avoid multiple walk-throughs of SCTP chunks in sctp_new(), sctp_basic_checks() and nf_conntrack_sctp_packet(), and parse it only once
> 	b) SCTP conntrack has the same state regardless of it is a primary or a secondary path
> 
> Let's say there are two SCTP endpoints A and B with addresses A' and B, B'' correspondingly.
> Primary path is A' <----> B' that traverses middlebox C, and secondary path is A' <----> B'' that traverses middlebox D.
> 1) SHUTDOWN sent on secondary path
> 1a) SCTP endpoint A sets up an association towards SCTP endpoint B
> 1b) Middlebox C sees INIT sequence and creates "primary" conntrack entry (5 days)
> 1c) Middlebox D sees HEARTBEAT sequence and creates "secondary" conntrack entry (210 seconds)
> 1d) Path failure between A and C, and SCTP endpoint A switches to secondary path and continues sending data on the association
> 1e) SCTP endpoint A decides to SHUTDOWN the connection
> 1f) Middlebox C is in ESTABLISHED state, doesn't see any SHUTDOWN sequence or HEARTBEAT, waits for timeout (5 days)
> 1g) Middlebox D is in HEARTBEAT_ACKED state, doesn't care about SHUTDOWN sequence, waits for timeout (210 seconds)

I guess similar problem will occur with MP-TCP, and I am not sure
taking TCP to be more stateless is the way to address this.

> 2) Recently fixed by bff3d0534804 ("netfilter: conntrack: add sctp DATA_SENT state ")
> 2a) SCTP endpoint A sets up an association towards SCTP endpoint B
> 2b) Middlebox C sees INIT sequence and creates "primary" conntrack entry (5 days)
> 2c) Middlebox D sees DATA/SACK, and DROPS packets until HEARTBEAT is seen to setup "secondary" conntrack entry (210 seconds)

I assume this is already fixed.

Another possibility would be to introduce this alternative
state-machine and use it for multihoming?
