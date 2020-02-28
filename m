Return-Path: <SRS0=BkHn=4Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FFAC3F2D2
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Feb 2020 12:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79C2E246AC
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Feb 2020 12:29:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZPRHMjj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgB1M3F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Feb 2020 07:29:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55143 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725730AbgB1M3F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 07:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582892943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X4WN5Ogf4KWsjJryYofQKszbC/mre6R6b/ap6nXrFqU=;
        b=WZPRHMjjxXt0/x53ogL6WjcZbjF/7iFMEA8rntwlUtBFm5rf7CkRv/Kzu8MbsGzbwUYSyR
        FgnAOYzHbT0xbYj1Z8a9mKIJXpOSjvemo3Tz00Z78kAEbYqrcpSlRppBTwka8Qy0fD8paO
        TvxDqekbw72x8Y7r+fCfAlijyxz5UhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-5HZ5YkQlNHGyDihW1GopYQ-1; Fri, 28 Feb 2020 07:28:59 -0500
X-MC-Unique: 5HZ5YkQlNHGyDihW1GopYQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D26D81083E80;
        Fri, 28 Feb 2020 12:28:58 +0000 (UTC)
Received: from localhost (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E42B510027BA;
        Fri, 28 Feb 2020 12:28:54 +0000 (UTC)
Date:   Fri, 28 Feb 2020 13:28:48 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
Message-ID: <20200228132848.4a0bf4b7@redhat.com>
In-Reply-To: <20200228124039.00e5a343@redhat.com>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
        <20200225094043.5a78337e@redhat.com>
        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
        <20200225132235.5204639d@redhat.com>
        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>
        <20200225215322.6fb5ecb0@redhat.com>
        <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>
        <20200228124039.00e5a343@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 28 Feb 2020 12:40:39 +0100
Stefano Brivio <sbrivio@redhat.com> wrote:

> Hi Jozsef,
> 
> On Thu, 27 Feb 2020 21:37:10 +0100 (CET)
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> 
> > Hi Stefano,
> > 
> > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> >   
> > > On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
> > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > >     
> > > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > > >     
> > > > > > The logic could be changed in the user rules from
> > > > > > 
> > > > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > > > 
> > > > > > to
> > > > > > 
> > > > > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > > > > > [ otherwise DROP ]
> > > > > > 
> > > > > > but of course it might be not so simple, depending on how the rules are 
> > > > > > built up.      
> > > > > 
> > > > > Yes, it would work, unless the user actually wants to check with the
> > > > > same counter how many bytes are sent "in excess".      
> > > > 
> > > > You mean the counters are still updated whenever the element is matched in 
> > > > the set and then one could check how many bytes were sent over the 
> > > > threshold just by listing the set elements.    
> > > 
> > > Yes, exactly -- note that it was possible (and, I think, used) before.    
> > 
> > I'm still not really convinced about such a feature. Why is it useful to 
> > know how many bytes would be sent over the "limit"?  
> 
> This is useful in case one wants different treatments for packets
> according to a number of thresholds in different rules. For example,
> 
>     iptables -I INPUT -m set --match-set c src --bytes-lt 100 -j noise
>     iptables -I noise -m set --match-set c src --bytes-lt 20000 -j download
                                                         ^^ gt, of
                                                         course :)

-- 
Stefano

