Return-Path: <SRS0=BkHn=4Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5819C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Feb 2020 11:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0E4A246A0
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Feb 2020 11:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TEBJk+jH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgB1Lkv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Feb 2020 06:40:51 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20368 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgB1Lkv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 06:40:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582890049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51b9CHD9jN6AHDokVTrETHRd1wKpWwLJIuf3FThjMPY=;
        b=TEBJk+jHnjHVfvOQjoBJ5qTDyXQ7v+rh0PoSvWKxclnm9/JGr/nPfQ1IG3gyddLW1oc/gJ
        Nr5FNUt7zjnUAgvzaoJ5VyZ6ikzP9PAEICuOtNF7JpnsczaiqRIIvuZYMSPB0jHeTx6EDA
        SklF1twQOYQ78ZZ0ae0yXCDZwU51PU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-27AVyINNO5yNOA5jKL4HAw-1; Fri, 28 Feb 2020 06:40:47 -0500
X-MC-Unique: 27AVyINNO5yNOA5jKL4HAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7146107ACC7;
        Fri, 28 Feb 2020 11:40:46 +0000 (UTC)
Received: from localhost (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90A9392972;
        Fri, 28 Feb 2020 11:40:45 +0000 (UTC)
Date:   Fri, 28 Feb 2020 12:40:39 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
Message-ID: <20200228124039.00e5a343@redhat.com>
In-Reply-To: <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
        <20200225094043.5a78337e@redhat.com>
        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
        <20200225132235.5204639d@redhat.com>
        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>
        <20200225215322.6fb5ecb0@redhat.com>
        <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Thu, 27 Feb 2020 21:37:10 +0100 (CET)
Jozsef Kadlecsik <kadlec@netfilter.org> wrote:

> Hi Stefano,
> 
> On Tue, 25 Feb 2020, Stefano Brivio wrote:
> 
> > On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
> > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> >   
> > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > >   
> > > > > The logic could be changed in the user rules from
> > > > > 
> > > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > > 
> > > > > to
> > > > > 
> > > > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > > > > [ otherwise DROP ]
> > > > > 
> > > > > but of course it might be not so simple, depending on how the rules are 
> > > > > built up.    
> > > > 
> > > > Yes, it would work, unless the user actually wants to check with the
> > > > same counter how many bytes are sent "in excess".    
> > > 
> > > You mean the counters are still updated whenever the element is matched in 
> > > the set and then one could check how many bytes were sent over the 
> > > threshold just by listing the set elements.  
> > 
> > Yes, exactly -- note that it was possible (and, I think, used) before.  
> 
> I'm still not really convinced about such a feature. Why is it useful to 
> know how many bytes would be sent over the "limit"?

This is useful in case one wants different treatments for packets
according to a number of thresholds in different rules. For example,

    iptables -I INPUT -m set --match-set c src --bytes-lt 100 -j noise
    iptables -I noise -m set --match-set c src --bytes-lt 20000 -j download

and you want to log packets from chains 'noise' and 'download' with
different prefixes.

> Also, there's no protection against overflow in the counters. I know
> firewalls with ipset, 10gb interfaces and long uptimes, so it's not
> completely a theoretical issue.

With 10GbE, 64-bit counters can cover more than:
  2 ^ 64 / (10 * 1000 * 1000 * 1000 / 8) = 14757395259 seconds
that is,
  14757395259 / (60 * 60 * 24) = 170803 days
that is,
  170803 / 365 = 468 years

...is that a real issue?

> > > > > I almost added to my previous mail that the 'ge' and 'gt' matches 
> > > > > are not really useful at the moment...  
> > > > 
> > > > ...yes, I can't think of any other use for those either.    
> > > 
> > > Those could really be useful if the counters could be decremented. 
> > > Otherwise I think the counter matching in the sets is not as useful as 
> > > it seems to be.  
> > 
> > Still, if counters are updated with just matching element, but not 
> > necessarily matching rule, they should be as useful as in the hypothesis 
> > of introducing a "decrementing" feature -- one just needs to adjust the 
> > rule logic to that.  
> 
> That's true.
> 
> > > > > The other possibility is to force counter update. I.e. instead of
> > > > > 
> > > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > > 
> > > > > something like
> > > > > 
> > > > > iptables -I INPUT -m set --match-set c src --update-counters \
> > > > > 	--bytes-gt 800 -j DROP
> > > > > 
> > > > > but that also requires some internal changes to store a new flag, because 
> > > > > at the moment only "! --update-counters" is supported. So there'd be then 
> > > > > a fine-grained control over how the counters are updated:
> > > > > 
> > > > > - no --update-counters flag: update counters only if the whole rule 
> > > > >   matches, including the counter matches
> > > > > - --update-counters flag: update counters if counter matching is false    
> > > > 
> > > > ...this should probably be "in any case", also if it's true.    
> > > 
> > > Yes, but now I don't really like the name itself: --force-update-counters
> > > or something like that would be more clear.
> > >   
> > > > > - ! --update-counters flag: don't update counters    
> > > > 
> > > > I think that would fix the issue as well, I'm just struggling to find a
> > > > sensible use case for the "no --update-counters" case -- especially one
> > > > where there would be a substantial issue with the change I proposed.    
> > > 
> > > The no update counter flag was introduced to handle when one needs to 
> > > match in the same set multiple times, i.e. there are multiple rules with 
> > > the same set. Like you need to match in the raw/mangle/filter tables as 
> > > well. Unfortunately I can't recall the usercase.  
> > 
> > Okay, but what you're describing is the "! --update-counters" option. 
> > That works, didn't work before 4750005a85f7, but would still work with 
> > this change.
> > 
> > What I meant is really the case where "--update-counters" (or 
> > "--force-update-counters") and "! --update-counters" are both absent: I 
> > don't see any particular advantage in the current behaviour for that 
> > case.  
> 
> The counters are used just for statistical purposes: reflect the 
> packets/bytes which were let through, i.e. matched the whole "rule".
> In that case updating the counters before the counter value matching is 
> evaluated gives false results.

Well, but for that, iptables/x_tables counters are available and
(as far as I know) typically used.

-- 
Stefano

