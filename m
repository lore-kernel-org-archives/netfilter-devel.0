Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CBEC35E0E
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D71724653
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRlRFG4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgBYUxl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:53:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21365 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728714AbgBYUxl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 15:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582664019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GcYdbK/UADvck/KvEakn5+pQ6uOGPYAAVRjqi4lI3gU=;
        b=FRlRFG4tIAVFsfh2DNmxqiTMpQ4K7nNsB5kJUBQhollzaoGxtN7T9W5s7F9hCwhfyEJ+DO
        ziOn9GfWqld45LndlsEFILP9hpVD7gf/F0RownFf9H4EQ0KantAtgfME1otAKh2bO72EWZ
        VoCKweaZLvlBG2BlQ2VI7U75XMq6zOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-IxNV3hNFOo-e9o_yc2n_XA-1; Tue, 25 Feb 2020 15:53:38 -0500
X-MC-Unique: IxNV3hNFOo-e9o_yc2n_XA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D550477;
        Tue, 25 Feb 2020 20:53:37 +0000 (UTC)
Received: from localhost (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8587B5C28C;
        Tue, 25 Feb 2020 20:53:35 +0000 (UTC)
Date:   Tue, 25 Feb 2020 21:53:22 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
Message-ID: <20200225215322.6fb5ecb0@redhat.com>
In-Reply-To: <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
        <20200225094043.5a78337e@redhat.com>
        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
        <20200225132235.5204639d@redhat.com>
        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
Jozsef Kadlecsik <kadlec@netfilter.org> wrote:

> On Tue, 25 Feb 2020, Stefano Brivio wrote:
> 
> > > The logic could be changed in the user rules from
> > > 
> > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > 
> > > to
> > > 
> > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > > [ otherwise DROP ]
> > > 
> > > but of course it might be not so simple, depending on how the rules are 
> > > built up.  
> > 
> > Yes, it would work, unless the user actually wants to check with the
> > same counter how many bytes are sent "in excess".  
> 
> You mean the counters are still updated whenever the element is matched in 
> the set and then one could check how many bytes were sent over the 
> threshold just by listing the set elements.

Yes, exactly -- note that it was possible (and, I think, used) before.

> > Now, I see the conceptual problem about matching: if the rule isn't 
> > matching, and counters count matched packets, counters shouldn't 
> > increase. But still, I think there are a number of facts to be 
> > considered:
> > 
> > - the man page says (and has said for a number of years):
> > 
> > 	If the packet is matched an element in the set, match only if
> > 	the byte counter of the element is greater than the given value
> > 	as well.
> > 
> >   which actually makes the problem undecidable: matching depends on
> >   matching itself. Trying some "common sense" interpretation, I would
> >   read this as:
> > 
> > 	If the packet matches an *element* in the set, this *rule* will
> > 	match only if the byte counter of the element is greater than
> > 	the given value.
> > 
> >   that is, by separating the meaning of "element matching" from "rule
> >   matching", this starts making sense.  
> 
> Yes, you are right. Sometimes I think I'm far from the best at writing 
> documentation... So I'm going to update the manpage with your sentence.

Wait, though: that's only the case if we update the counters for
matching *elements* and not necessarily matching *rules*, which was the
case before 4750005a85f7, or with this patch.

Otherwise, the sentence I wrote is not accurate. I can try to come up
with another one to describe the current behaviour, but I'll need some
calm minutes with pencil and paper tomorrow.

> > - I spent the past two hours trying to think of an actual case that was
> >   affected by 4750005a85f7, *other than the "main" bug it fixes*, that
> >   is, "! --update-counters" was ignored altogether, and I couldn't.
> > 
> >   Even if we had a --bytes-lt option, it would be counter-intuitive,
> >   because the counter would be updated until bytes are less than the
> >   threshold, and then the rule would stop matching, meaning that the
> >   user most probably thinks:
> > 
> > 	"Drop matching packets as long as less than 800 bytes are sent"
> > 
> >   and what happens is:
> > 
> > 	"Count and drop matching packets until 800 bytes are sent, then
> > 	stop dropping and counting them"  
> 
> Again, yes, that's what would happen.
> 
> >   The only "functional" case I can think of is something like
> >   --bytes-lt 800 -j ACCEPT. User probably thinks:
> > 
> > 	"Don't let more than 800 bytes go through"
> > 
> >   and what happens is:
> > 
> > 	"Let up to 800 bytes, or 799 bytes plus one packet, go through,
> > 	counting the bytes in packets that were let through"
> > 
> >   which isn't much different from the expectation.
> > 
> > - and then,
> >   
> > > > Other than this, I'm a bit confused. How could --packets-gt and
> > > > --bytes-gt be used, if counters don't increase as long as the rule
> > > > doesn't match?    
> > > 
> > > I almost added to my previous mail that the 'ge' and 'gt' matches are not 
> > > really useful at the moment...  
> > 
> > ...yes, I can't think of any other use for those either.  
> 
> Those could really be useful if the counters could be decremented. 
> Otherwise I think the counter matching in the sets is not as useful as it 
> seems to be.

Still, if counters are updated with just matching element, but not
necessarily matching rule, they should be as useful as in the hypothesis
of introducing a "decrementing" feature -- one just needs to adjust the
rule logic to that.

> > > > > What's really missing is a decrement-counters flag: that way one could 
> > > > > store different "quotas" for the elements in a set.    
> > > > 
> > > > I see, that would work as well.    
> > > 
> > > The other possibility is to force counter update. I.e. instead of
> > > 
> > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > 
> > > something like
> > > 
> > > iptables -I INPUT -m set --match-set c src --update-counters \
> > > 	--bytes-gt 800 -j DROP
> > > 
> > > but that also requires some internal changes to store a new flag, because 
> > > at the moment only "! --update-counters" is supported. So there'd be then 
> > > a fine-grained control over how the counters are updated:
> > > 
> > > - no --update-counters flag: update counters only if the whole rule 
> > >   matches, including the counter matches
> > > - --update-counters flag: update counters if counter matching is false  
> > 
> > ...this should probably be "in any case", also if it's true.  
> 
> Yes, but now I don't really like the name itself: --force-update-counters
> or something like that would be more clear.
> 
> > > - ! --update-counters flag: don't update counters  
> > 
> > I think that would fix the issue as well, I'm just struggling to find a
> > sensible use case for the "no --update-counters" case -- especially one
> > where there would be a substantial issue with the change I proposed.  
> 
> The no update counter flag was introduced to handle when one needs to 
> match in the same set multiple times, i.e. there are multiple rules with 
> the same set. Like you need to match in the raw/mangle/filter tables as 
> well. Unfortunately I can't recall the usercase.

Okay, but what you're describing is the "! --update-counters" option.
That works, didn't work before 4750005a85f7, but would still work with
this change.

What I meant is really the case where "--update-counters" (or
"--force-update-counters") and "! --update-counters" are both absent: I
don't see any particular advantage in the current behaviour for that
case.

-- 
Stefano

