Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F30C35669
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 22:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9181206D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 22:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bWt64A0W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgBUWXA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 17:23:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33706 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726731AbgBUWXA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 17:23:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582323778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eYSh+NjjI5jwez7yoZ1qKRw0KGRSyFWU7MwKYay9DEg=;
        b=bWt64A0Wg2M16yK/y2B+zPC6YnzBbvUDkwY2pVNe94XBPas+GQLg2mOQEipJPT1dCYofKp
        f50XPzRPnkt2vuK/pxwdK3C327Jv7CCPcEEbu3EVh0hG9UFsF7y3G7soMK0YC7nlDADk3o
        1yTmhzu5Pqrt2Y3YEAinf8DwCG5B0/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-cNwB1JReNduTRXcPp0_dBA-1; Fri, 21 Feb 2020 17:22:53 -0500
X-MC-Unique: cNwB1JReNduTRXcPp0_dBA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A76E801E67;
        Fri, 21 Feb 2020 22:22:51 +0000 (UTC)
Received: from elisabeth (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DAED60C99;
        Fri, 21 Feb 2020 22:22:48 +0000 (UTC)
Date:   Fri, 21 Feb 2020 23:22:18 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200221232218.2157d72b@elisabeth>
In-Reply-To: <20200221211704.GM20005@orbyte.nwl.cc>
References: <cover.1582250437.git.sbrivio@redhat.com>
        <20200221211704.GM20005@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Fri, 21 Feb 2020 22:17:04 +0100
Phil Sutter <phil@nwl.cc> wrote:

> Hi Stefano,
> 
> On Fri, Feb 21, 2020 at 03:04:20AM +0100, Stefano Brivio wrote:
> > Patch 1/2 fixes the issue recently reported by Phil on a sequence of
> > add/flush/add operations, and patch 2/2 introduces a test case
> > covering that.  
> 
> This fixes my test case, thanks!
> 
> I found another problem, but it's maybe on user space side (and not a
> crash this time ;):
> 
> | # nft add table t
> | # nft add set t s '{ type inet_service . inet_service ; flags interval ; }
> | # nft add element t s '{ 20-30 . 40, 25-35 . 40 }'
> | # nft list ruleset
> | table ip t {
> | 	set s {
> | 		type inet_service . inet_service
> | 		flags interval
> | 		elements = { 20-30 . 40 }
> | 	}
> | }
> 
> As you see, the second element disappears. It happens only if ranges
> overlap and non-range parts are identical.
>
> Looking at do_add_setelems(), set_to_intervals() should not be called
> for concatenated ranges, although I *think* range merging happens only
> there. So user space should cover for that already?!

Yes. I didn't consider the need for this kind of specification, given
that you can obtain the same result by simply adding two elements:
separate, partially overlapping elements can be inserted (which is, if I
recall correctly, not the case for rbtree).

If I recall correctly, we had a short discussion with Florian about
this, but I don't remember the conclusion.

However, I see the ugliness, and how this breaks probably legitimate
expectations. I guess we could call set_to_intervals() in this case,
that function might need some minor adjustments.

An alternative, and I'm not sure which one is the most desirable, would
be to refuse that kind of insertion.

-- 
Stefano

