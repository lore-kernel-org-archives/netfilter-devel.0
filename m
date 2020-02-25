Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDBDC35DF5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 08:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C6E20CC7
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 08:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtSjklgQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgBYIky (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 03:40:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30548 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726867AbgBYIky (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 03:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582620053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yJ/EJW8ZYf2J9M9aTFprhTHj+7BpbIJjHk/Cd36I6vA=;
        b=WtSjklgQkMAYzIvo2ZzEqiDQsV06gul2nlGVywq0c/cwwTdZVGDy/djRU3AFw5aV5xSdJd
        6xraGcj2m2R9XEQ8LwEGQ5XwRDRkTier5tN/9f5255AskGQESk7EUUk02G+BElhHxwq/9i
        xaQSRuz6BPiSrDpvyD5LR7U0Z39QkIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-ZOLrzlzpNNOp78DcKUUrRQ-1; Tue, 25 Feb 2020 03:40:51 -0500
X-MC-Unique: ZOLrzlzpNNOp78DcKUUrRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5210F107ACC9;
        Tue, 25 Feb 2020 08:40:50 +0000 (UTC)
Received: from localhost (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA2E810013A1;
        Tue, 25 Feb 2020 08:40:48 +0000 (UTC)
Date:   Tue, 25 Feb 2020 09:40:43 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
Message-ID: <20200225094043.5a78337e@redhat.com>
In-Reply-To: <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Tue, 25 Feb 2020 09:07:09 +0100 (CET)
Jozsef Kadlecsik <kadlec@netfilter.org> wrote:

> Hi Stefano MithilMithil,
> 
> On Mon, 24 Feb 2020, Stefano Brivio wrote:
> 
> > In ip_set_match_extensions(), for sets with counters, we take care of 
> > updating counters themselves by calling ip_set_update_counter(), and of 
> > checking if the given comparison and values match, by calling 
> > ip_set_match_counter() if needed.
> > 
> > However, if a given comparison on counters doesn't match the configured 
> > values, that doesn't mean the set entry itself isn't matching.
> > 
> > This fix restores the behaviour we had before commit 4750005a85f7 
> > ("netfilter: ipset: Fix "don't update counters" mode when counters used 
> > at the matching"), without reintroducing the issue fixed there: back 
> > then, mtype_data_match() first updated counters in any case, and then 
> > took care of matching on counters.
> > 
> > Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
> > ip_set_update_counter() will anyway skip counter updates if desired.
> > 
> > The issue observed is illustrated by this reproducer:
> > 
> >   ipset create c hash:ip counters
> >   ipset add c 192.0.2.1
> >   iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > 
> > if we now send packets from 192.0.2.1, bytes and packets counters
> > for the entry as shown by 'ipset list' are always zero, and, no
> > matter how many bytes we send, the rule will never match, because
> > counters themselves are not updated.  
> 
> Sorry, but I disagree. ipset behaves the same as iptables itself: the 
> counters are increased when the whole rule matches and that includes the 
> counter comparison as well. I think it's less counter-intuitive that one 
> can create never matching rules than to explain that "counter matching is 
> a non-match for the point of view of 'when the rule matches, update the 
> counter'".

Note that this behaviour was modified two years ago: earlier, this was
not the case (and by the way this is how we found out, as it broke a
user setup).

Other than this, I'm a bit confused. How could --packets-gt and
--bytes-gt be used, if counters don't increase as long as the rule
doesn't match?

> What's really missing is a decrement-counters flag: that way one could 
> store different "quotas" for the elements in a set.

I see, that would work as well.

-- 
Stefano

