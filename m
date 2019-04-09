Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F814C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6674E2084B
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfDINxV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfDINxV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:53:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C0F7A307D978;
        Tue,  9 Apr 2019 13:53:20 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.phx2.redhat.com [10.3.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B89C5C28D;
        Tue,  9 Apr 2019 13:53:06 +0000 (UTC)
Date:   Tue, 9 Apr 2019 09:53:04 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
Message-ID: <20190409135304.rgkcpgya6h3ciphy@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
 <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 09 Apr 2019 13:53:21 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-04-09 09:40, Paul Moore wrote:
> On Tue, Apr 9, 2019 at 8:58 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
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

While this particular message type is used very infrequently, adding a
version field to every message type strikes me as a huge overhead for
the small likelihood of the format needing to change.

I'd prefer to just key it off the AUDIT_FEATURE_BITMAP or some other
easily detectable change in this distinguishing feature, such as the
presence of /proc/self/audit_containerid, which is what I've done in the
accompanying userspace patchset that I'm preparing to post that works
with this change.

Neil, you are right that netlink has useful mechanisms to help with this
sort of thing, but we're not quite there yet.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
