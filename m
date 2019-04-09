Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE13C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84CC32084B
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDINtb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:49:31 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32966 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfDINtb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:49:31 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-188a.dyn6.twc.com ([2606:a000:111b:405a::188a] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hDr7p-00012u-Dr; Tue, 09 Apr 2019 09:49:23 -0400
Date:   Tue, 9 Apr 2019 09:48:52 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
Message-ID: <20190409134852.GB15660@hmswarspite.think-freely.org>
References: <cover.1554732921.git.rgb@redhat.com>
 <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
 <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 09, 2019 at 09:40:58AM -0400, Paul Moore wrote:
> On Tue, Apr 9, 2019 at 8:58 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >
> > On Tue, Apr 9, 2019 at 5:40 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Add audit container identifier support to the action of signalling the
> > > audit daemon.
> > >
> > > Since this would need to add an element to the audit_sig_info struct,
> > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > audit_sig_info2 struct.  Corresponding support is required in the
> > > userspace code to reflect the new record request and reply type.
> > > An older userspace won't break since it won't know to request this
> > > record type.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> >
> > This looks good to me.
> >
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> >
> > Although I'm wondering if we shouldn't try to future-proof the
> > AUDIT_SIGNAL_INFO2 format somehow, so that we don't need to add
> > another AUDIT_SIGNAL_INFO3 when the need arises to add yet-another
> > identifier to it... The simplest solution I can come up with is to add
> > a "version" field at the beginning (set to 2 initially), then v<N>_len
> > at the beginning of data for version <N>. But maybe this is too
> > complicated for too little gain...
> 
> FWIW, I believe the long term solution to this is the fabled netlink
> attribute approach that we haven't talked about in some time, but I
> keep dreaming about (it has been mostly on the back burner becasue 1)
> time and 2) didn't want to impact the audit container ID work).  While
> I'm not opposed to trying to make things like this a bit more robust
> by adding version fields and similar things, there are still so many
> (so very many) problems with the audit kernel/userspace interface that
> still need to be addressed.
> 

Agreed, this change as-is is in keeping with the message structure that audit
has today, and so is ok with me, but the long term goal should be a conversion
to netlink attributes for all audit messages.  Thats a big undertaking and
should be addressed separately though.

Neil

> -- 
> paul moore
> www.paul-moore.com
> 
