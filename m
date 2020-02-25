Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CF5C35DF5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 12:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F249218AC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 12:22:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ScfbeSAU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgBYMWr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 07:22:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22918 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729048AbgBYMWr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 07:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582633365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUVkCcViHJNyMjyR3lNXnG0D3CNpTBa2tAMYXyl88vY=;
        b=ScfbeSAU+s80JICFiZbWs1jPBpDdMHCM3puh62MFiabv6dTKXl9FT0ZtM5eJFXL5z3ZkSH
        6koef9Ms3umhusIoheT7Je0wKk4koj0v/g3NLhxGwNU23Tjg7xc82gVxO9jsGwnMwpEciE
        4Ix3qL8hDTES63xdFCaHtA51xi63BSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-NXQDKpCoOCuq5aj4cdjdiQ-1; Tue, 25 Feb 2020 07:22:44 -0500
X-MC-Unique: NXQDKpCoOCuq5aj4cdjdiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F05698017DF;
        Tue, 25 Feb 2020 12:22:42 +0000 (UTC)
Received: from localhost (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AC631001B09;
        Tue, 25 Feb 2020 12:22:40 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:22:35 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
Message-ID: <20200225132235.5204639d@redhat.com>
In-Reply-To: <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
        <20200225094043.5a78337e@redhat.com>
        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 25 Feb 2020 10:16:40 +0100 (CET)
Jozsef Kadlecsik <kadlec@netfilter.org> wrote:

> Hi Stefano,
> 
> On Tue, 25 Feb 2020, Stefano Brivio wrote:
> 
> > > > The issue observed is illustrated by this reproducer:
> > > > 
> > > >   ipset create c hash:ip counters
> > > >   ipset add c 192.0.2.1
> > > >   iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > 
> > > > if we now send packets from 192.0.2.1, bytes and packets counters
> > > > for the entry as shown by 'ipset list' are always zero, and, no
> > > > matter how many bytes we send, the rule will never match, because
> > > > counters themselves are not updated.    
> > > 
> > > Sorry, but I disagree. ipset behaves the same as iptables itself: the 
> > > counters are increased when the whole rule matches and that includes the 
> > > counter comparison as well. I think it's less counter-intuitive that one 
> > > can create never matching rules than to explain that "counter matching is 
> > > a non-match for the point of view of 'when the rule matches, update the 
> > > counter'".  
> > 
> > Note that this behaviour was modified two years ago: earlier, this was 
> > not the case (and by the way this is how we found out, as it broke a 
> > user setup).  
> 
> That's  really bad. Still, I think it was a bug earlier which was 
> then fixed. The logic could be changed in the user rules from
> 
> iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> 
> to
> 
> iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> [ otherwise DROP ]
> 
> but of course it might be not so simple, depending on how the rules are 
> built up.

Yes, it would work, unless the user actually wants to check with the
same counter how many bytes are sent "in excess".

Now, I see the conceptual problem about matching: if the rule isn't
matching, and counters count matched packets, counters shouldn't
increase. But still, I think there are a number of facts to
be considered:

- the man page says (and has said for a number of years):

	If the packet is matched an element in the set, match only if
	the byte counter of the element is greater than the given value
	as well.

  which actually makes the problem undecidable: matching depends on
  matching itself. Trying some "common sense" interpretation, I would
  read this as:

	If the packet matches an *element* in the set, this *rule* will
	match only if the byte counter of the element is greater than
	the given value.

  that is, by separating the meaning of "element matching" from "rule
  matching", this starts making sense.

- I spent the past two hours trying to think of an actual case that was
  affected by 4750005a85f7, *other than the "main" bug it fixes*, that
  is, "! --update-counters" was ignored altogether, and I couldn't.

  Even if we had a --bytes-lt option, it would be counter-intuitive,
  because the counter would be updated until bytes are less than the
  threshold, and then the rule would stop matching, meaning that the
  user most probably thinks:

	"Drop matching packets as long as less than 800 bytes are sent"

  and what happens is:

	"Count and drop matching packets until 800 bytes are sent, then
	stop dropping and counting them"

  The only "functional" case I can think of is something like
  --bytes-lt 800 -j ACCEPT. User probably thinks:

	"Don't let more than 800 bytes go through"

  and what happens is:

	"Let up to 800 bytes, or 799 bytes plus one packet, go through,
	counting the bytes in packets that were let through"

  which isn't much different from the expectation.

- and then,

> > Other than this, I'm a bit confused. How could --packets-gt and
> > --bytes-gt be used, if counters don't increase as long as the rule
> > doesn't match?  
> 
> I almost added to my previous mail that the 'ge' and 'gt' matches are not 
> really useful at the moment...

...yes, I can't think of any other use for those either.

> > > What's really missing is a decrement-counters flag: that way one could 
> > > store different "quotas" for the elements in a set.  
> > 
> > I see, that would work as well.  
> 
> The other possibility is to force counter update. I.e. instead of
> 
> iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> 
> something like
> 
> iptables -I INPUT -m set --match-set c src --update-counters \
> 	--bytes-gt 800 -j DROP
> 
> but that also requires some internal changes to store a new flag, because 
> at the moment only "! --update-counters" is supported. So there'd be then 
> a fine-grained control over how the counters are updated:
> 
> - no --update-counters flag: update counters only if the whole rule 
>   matches, including the counter matches
> - --update-counters flag: update counters if counter matching is false

...this should probably be "in any case", also if it's true.

> - ! --update-counters flag: don't update counters

I think that would fix the issue as well, I'm just struggling to find a
sensible use case for the "no --update-counters" case -- especially one
where there would be a substantial issue with the change I proposed.

-- 
Stefano

