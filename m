Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268EDC63797
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 12:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbjAQMB4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 07:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236132AbjAQMBz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 07:01:55 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D407D35279
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 04:01:54 -0800 (PST)
Date:   Tue, 17 Jan 2023 13:01:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH 3/3] netfilter: conntrack: unify established states for
 SCTP paths
Message-ID: <Y8aOLydRlSqemdf/@salvia>
References: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
 <20230116093556.9437-4-sriram.yagnaraman@est.tech>
 <Y8aMgOo0XImPyS54@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8aMgOo0XImPyS54@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 17, 2023 at 12:54:40PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 16, 2023 at 10:35:56AM +0100, Sriram Yagnaraman wrote:
> > An SCTP endpoint can start an association through a path and tear it
> > down over another one. That means the initial path will not see the
> > shutdown sequence, and the conntrack entry will remain in ESTABLISHED
> > state for 5 days.
> > 
> > By merging the HEARTBEAT_ACKED and ESTABLISHED states into one
> > ESTABLISHED state, there remains no difference between a primary or
> > secondary path. The timeout for the merged ESTABLISHED state is set to
> > 210 seconds (hb_interval * max_path_retrans + rto_max). So, even if a
> > path doesn't see the shutdown sequence, it will expire in a reasonable
> > amount of time.
> > 
> > Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > ---
> >  .../uapi/linux/netfilter/nf_conntrack_sctp.h  |  4 +-
> >  .../linux/netfilter/nfnetlink_cttimeout.h     |  4 +-
> >  net/netfilter/nf_conntrack_proto_sctp.c       | 90 ++++++++-----------
> >  net/netfilter/nf_conntrack_standalone.c       | 16 ----
> >  4 files changed, 42 insertions(+), 72 deletions(-)
> > 
> > diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> > index c742469afe21..150fc3c056ea 100644
> > --- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> > +++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> > @@ -15,8 +15,8 @@ enum sctp_conntrack {
> >  	SCTP_CONNTRACK_SHUTDOWN_RECD,
> >  	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
> >  	SCTP_CONNTRACK_HEARTBEAT_SENT,
> > -	SCTP_CONNTRACK_HEARTBEAT_ACKED,
> > -	SCTP_CONNTRACK_DATA_SENT,
> > +	SCTP_CONNTRACK_HEARTBEAT_ACKED,	/* no longer used */
> > +	SCTP_CONNTRACK_DATA_SENT,	/* no longer used */
> 
> _DATA_SENT was added in the previous development cycle, to my
> knowledged it has been present in 6.1-rc only. Then I think you can

Actually, I mean 6.2-rc releases.

> post a patch to revert this explaining why there is no need for
> _DATA_SENT anymore. You can revert it before this patch (with my
> suggestion, your series will contain with 4 patches).
> 
> One question of mine: Did you extract the new established timeout from
> RFC, where this formula came from?
> 
> 210 seconds = hb_interval * max_path_retrans + rto_max
> 
> And thanks, if this works for you, I prefer this incremental approach
> by improving the existing SCTP tracker.
