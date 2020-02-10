Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D718DC352A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 19:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A47EB20873
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 19:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TGANoTTL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBJTNg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 14:13:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726831AbgBJTNf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 14:13:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581362014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VP+9ORQBFbYqxw8SON+3XZw4F2/58qApLFJoNRxj/8g=;
        b=TGANoTTLIIPlyzL1fNtxsqA2+wDLnVkS7a8l3wta9HYn1kyintaVjWf+YfD/xqQ/k+blrz
        MxDdjIvSx8PbMlHv3JNlbV2WzKkhku6zuk7oFCPFsFgt/FXjGl9vDaWvj1Q0vp/Jhk4h9T
        lNCGV3OmHc+g3bxIckw9XNSM2hiMe44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-ePpTtxC0Od61N3rMM4hVWg-1; Mon, 10 Feb 2020 14:13:31 -0500
X-MC-Unique: ePpTtxC0Od61N3rMM4hVWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8736107ACC9;
        Mon, 10 Feb 2020 19:13:29 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 415775C103;
        Mon, 10 Feb 2020 19:13:21 +0000 (UTC)
Date:   Mon, 10 Feb 2020 14:13:18 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 1/9] netfilter: normalize x_table function
 declarations
Message-ID: <20200210191318.yubldkszlh55wvdt@madcap2.tricolour.ca>
References: <cover.1577830902.git.rgb@redhat.com>
 <194bdc565d548a14e12357a7c1a594605b7fdf0f.1577830902.git.rgb@redhat.com>
 <CAHC9VhT9T-UMnu6bWdd733XB6QaP+Sm3KWhdy828RN_FVWBMmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhT9T-UMnu6bWdd733XB6QaP+Sm3KWhdy828RN_FVWBMmw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-01-30 22:17, Paul Moore wrote:
> On Mon, Jan 6, 2020 at 1:54 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Git context diffs were being produced with unhelpful declaration types
> > in the place of function names to help identify the funciton in which
>                                                       ^^^^^^^^
>                                                       function
> > changes were made.
> >
> > Normalize x_table function declarations so that git context diff
> > function labels work as expected.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  net/netfilter/x_tables.c | 43 ++++++++++++++++++-------------------------
> >  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> Considering that this patch is a style change in code outside of
> audit, and we want to merge this via the audit tree, I think it is
> best if you drop the style changes from this patchset.  You can always
> submit them later to the netfilter developers.

Fair enough.  They were intended to help make the audit patches cleaner
by giving proper function name context in the diff, but I'll address the
issues and re-submit via netfilter-devel.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

