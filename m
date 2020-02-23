Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2ABC35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49920206E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:23:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9NIYWfB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWVXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 16:23:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40459 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726302AbgBWVXQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 16:23:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582492993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JCmiVf+x0Bh9vLnYo28POsFV+VYVr1kyehTTAfhV58=;
        b=J9NIYWfB7DqRhVaA5A2r9xGkmg2L4KrI62/9SfY4uANSMWbWNRbCZBBfQGJr4ohIf0G+hH
        MNmJEsSd5mUKIR+/JabmDWt+woz5ZoAQsKW9jvK4+DVxjHJkp1Aj3Vcp21CKxFgGHHv0Hq
        oShcTMjNssiqVc/hgQ+k4F0xvBeW7G4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-wVU-FzL0N1Oz68DBlspxdQ-1; Sun, 23 Feb 2020 16:23:09 -0500
X-MC-Unique: wVU-FzL0N1Oz68DBlspxdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1735F1005513;
        Sun, 23 Feb 2020 21:23:08 +0000 (UTC)
Received: from localhost (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B45CB90F5B;
        Sun, 23 Feb 2020 21:23:05 +0000 (UTC)
Date:   Sun, 23 Feb 2020 22:22:58 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200223222258.2bb7516a@redhat.com>
In-Reply-To: <20200222011933.GO20005@orbyte.nwl.cc>
References: <cover.1582250437.git.sbrivio@redhat.com>
        <20200221211704.GM20005@orbyte.nwl.cc>
        <20200221232218.2157d72b@elisabeth>
        <20200222011933.GO20005@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Sat, 22 Feb 2020 02:19:33 +0100
Phil Sutter <phil@nwl.cc> wrote:

> Hi Stefano,
> 
> On Fri, Feb 21, 2020 at 11:22:18PM +0100, Stefano Brivio wrote:
> > On Fri, 21 Feb 2020 22:17:04 +0100
> > Phil Sutter <phil@nwl.cc> wrote:
> >   
> > > Hi Stefano,
> > > 
> > > On Fri, Feb 21, 2020 at 03:04:20AM +0100, Stefano Brivio wrote:  
> > > > Patch 1/2 fixes the issue recently reported by Phil on a sequence of
> > > > add/flush/add operations, and patch 2/2 introduces a test case
> > > > covering that.    
> > > 
> > > This fixes my test case, thanks!
> > > 
> > > I found another problem, but it's maybe on user space side (and not a
> > > crash this time ;):
> > > 
> > > | # nft add table t
> > > | # nft add set t s '{ type inet_service . inet_service ; flags interval ; }
> > > | # nft add element t s '{ 20-30 . 40, 25-35 . 40 }'
> > > | # nft list ruleset
> > > | table ip t {
> > > | 	set s {
> > > | 		type inet_service . inet_service
> > > | 		flags interval
> > > | 		elements = { 20-30 . 40 }
> > > | 	}
> > > | }
> > > 
> > > As you see, the second element disappears. It happens only if ranges
> > > overlap and non-range parts are identical.
> > >
> > > Looking at do_add_setelems(), set_to_intervals() should not be called
> > > for concatenated ranges, although I *think* range merging happens only
> > > there. So user space should cover for that already?!  
> > 
> > Yes. I didn't consider the need for this kind of specification, given
> > that you can obtain the same result by simply adding two elements:
> > separate, partially overlapping elements can be inserted (which is, if I
> > recall correctly, not the case for rbtree).
> > 
> > If I recall correctly, we had a short discussion with Florian about
> > this, but I don't remember the conclusion.
> > 
> > However, I see the ugliness, and how this breaks probably legitimate
> > expectations. I guess we could call set_to_intervals() in this case,
> > that function might need some minor adjustments.
> > 
> > An alternative, and I'm not sure which one is the most desirable, would
> > be to refuse that kind of insertion.  
> 
> I don't think having concatenated ranges not merge even if possible is a
> problem. It's just a "nice feature" with some controversial aspects.
> 
> The bug I'm reporting is that Above 'add element' command passes two
> elements to nftables but only the first one makes it into the set. If
> overlapping elements are fine in pipapo, they should both be there. If
> not (or otherwise unwanted), we better error out instead of silently
> dropping the second one.

Indeed, I agree there's a blatant bug, I was just wondering how to
solve it.

I found out from notes with an old discussion with Florian what the
problem really was: for concatenated ranges, we might have stuff like:

	'{ 20-30 . 40-50, 25-35 . 45-50 }'

And the only sane way to handle this is as two separate elements. Also
note that I gave a rather confusing description of the behaviour with
"partially overlapping elements": what can partially overlap are ranges
within one field, but there can't be an overlap (even partial) over the
whole concatenation, because that creates ambiguity. That is,

	'{ 20-30 . 40, 25-35 . 40 }'

the "second element" here is not allowed, while:

	'{ 20-30 . 40, 25-35 . 41 }'

these elements both are.

Now, this turns into a question for Pablo. I started digging a bit
further, and I think that both userspace and nft_pipapo_insert()
observe a reasonable behaviour here: nft passes those as two elements,
nft_pipapo_insert() rejects the second one with -EEXIST.

However, in nft_add_set_elem(), we hit this:

	err = set->ops->insert(ctx->net, set, &elem, &ext2);
	if (err) {
		if (err == -EEXIST) {
			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF)) {
				err = -EBUSY;
				goto err_element_clash;
			}
			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
			     memcmp(nft_set_ext_data(ext),
				    nft_set_ext_data(ext2), set->dlen) != 0) ||
			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
				err = -EBUSY;
			else if (!(nlmsg_flags & NLM_F_EXCL))
				err = 0;
		}
		goto err_element_clash;
	}

and, in particular, as there's no "data" or "objref" extension
associated with the elements, we hit the:

	if (!(nlmsg_flags & NLM_F_EXCL))

clause, introduced by commit c016c7e45ddf ("netfilter: nf_tables: honor
NLM_F_EXCL flag in set element insertion"). The error is reset, and we
return success, but the set back-end indicated a problem.

Now, if NLM_F_EXCL is not passed and the entry the user wants to add is
already present, even though I'd give RFC 3549 a different
interpretation (we won't replace the entry, but we should still report
the error IMHO), I see why we might return success in this case.

The additional problem with concatenated ranges here is that the entry
might be conflicting (overlapping over the whole concatenation), but
not be the same as the user wants to insert. I think -EEXIST is the
code that still fits best in this case, so... do you see a better
alternative than changing nft_pipapo_insert() to return, say, -EINVAL?

-- 
Stefano

