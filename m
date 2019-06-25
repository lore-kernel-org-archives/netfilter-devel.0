Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B50C48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 14:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C500D208CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 14:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kaechele.ca header.i=@kaechele.ca header.b="ExNhw4fs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfFYOpI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 10:45:08 -0400
Received: from mail.fetzig.org ([54.39.219.108]:47520 "EHLO mail.fetzig.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730505AbfFYOpI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 10:45:08 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: felix@fetzig.org)
        by mail.fetzig.org (Postfix) with ESMTPSA id 4C63580DC9;
        Tue, 25 Jun 2019 10:45:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kaechele.ca;
        s=kaechele.ca-201608; t=1561473904;
        bh=fS4I7kOBxUvrTxkRuuUTcvysj3lpXYaK0A1wBmhc3XI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ExNhw4fsa4mR7hkOFQHEZChoIX6gIqcJHTMaQAzTHL5JCHCZHXHCfLy8DbPXbVtch
         lf3ZWJJc13iK63i+ax4CnBwcF3gmgrN7jbMHg3dYdeAM+64V4YxtulbU3f5y0vw+J4
         vujJxtIdYBTcr1JyRBX3tzMvB0lJgvxAd1DJvb9ehA/wp1MpaRp10atsGkymWkH1mq
         dzQy5rdQ6136WPDzFvsvkdkIMnpMkMM+PsV4wl1uLKWt4FMOWhIfw5LKDnRnSSlK4b
         DNurcnUuGvxisDQqVXSuRh69vJQDCIuYlAGwtlQ0YG6QZpEd6lonf3DTGMAtNs9t5j
         Y1jdpYk4xb9dg==
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
 <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca>
 <20190624235816.vw6ahepdgvxhvdej@salvia>
 <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca>
 <20190625080853.d6f523cimgg2u44v@salvia>
 <0904a616-106c-91de-ed55-97973aa5c330@kaechele.ca>
 <CAKfDRXjun=cVovtn70jxwTc9pa0hhDHUSdZjLHJC1Xw2AMG+rA@mail.gmail.com>
From:   Felix Kaechele <felix@kaechele.ca>
Message-ID: <04ab8f2d-2b50-8d99-2fa1-837b7acaf417@kaechele.ca>
Date:   Tue, 25 Jun 2019 10:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfDRXjun=cVovtn70jxwTc9pa0hhDHUSdZjLHJC1Xw2AMG+rA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.2 at pandora.fk.cx
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-06-25 7:52 a.m., Kristian Evensen wrote:

> I am sorry for the trouble that my change has caused.

No worries. I appreciate you taking the time helping me out.

>> this patch is giving me some trouble as it breaks deletion of conntrack
>> entries in software that doesn't set the version flag to anything else
>> but 0.
> 
> I might be a bit slow, but I have some trouble understanding this
> sentence. Is what you are saying that software that sets version to
> anything but 0 breaks?

Yeah, definitely not my best work of prose ;-)
What I was trying to say is: Any software that remains with the version 
set to 0 will not work. By association, since libnetfilter_conntrack 
explicitly sets the version to 0, anything that uses 
libnetfilter_conntrack will be unable to delete a specific entry in the 
conntrack table.

> According to the discussion triggered by the
> patch adding the feature that we fix here (see the thread [PATCH
> 07/31] netfilter: ctnetlink: Support L3 protocol-filter on flush),
> using the version field is the correct solution. Pablo wrote:
> 
>> The version field was meant to deal with this case.
>>
>> It has been not unused so far because we had no good reason.
> 
> So I guess Nicholas worry was correct, that there are applications
> that leave version uninitialized and they trigger the regression. I
> will let others decide if not setting version counts as a regression
> or incorrect API usage. If an uninitialized version counts as a
> regression, I am fine with reverting and will try to come up with
> another approach. However, I guess we now might have users that depend
> on the new behavior of flush as well.

I believe that's not the issue here.

So here's what my understanding is of what is happening:

Let's go back to that line of code:

u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;

Just to make sure I understand this correctly: If the version is set to 
0 the address family (l3proto) will be set to AF_UNSPEC regardless of 
what the actual l3proto was set to by the user of the API.
It is only set to the value chosen by the if the version is set to a 
non-null value.
We assume that all clients that require the old behaviour set their 
version to 0, since that's the only valid value to set it to at this 
point anyway.

The problem that arises from this:
When creating a conntrack entry with libnetfilter_conntrack it will 
happly accept the address family you supply. Let's assume we create an 
entry where AF_INET is supplied.
The entry will be created with AF_INET as it's l3proto. Hence, the tuple 
and its hash are only going to be matched upon search if the l3proto 
matches as well.

Now, when you try to delete an entry using libnetfilter_conntrack it 
will explicitly set it's version to 0 in the process of creating the 
message to the API, as it usually does.
Therefor the kernel, under the new behaviour, will disregard the l3proto 
and set AF_UNSPEC instead. By doing this we have created a new tuple 
with a hash that is different from the hash of the tuple that was used 
when creating the conntrack entry, since it was initially created with 
AF_INET, not AF_UNSPEC.
Therefor the search will turn up with no results as the tuples we 
actually want to match are now different, after AF_INET was yanked and 
AF_UNSPEC was put in.
Because the search doesn't find the entry we're trying to delete it will 
return ENOENT and our entry will not be deleted.

I hope my description is somewhat comprehensible. I'm basically thinking 
out loud here.

I have to admit that I also don't know how to approach this in a way 
that will not break userspace but also satisfy the requirements of users 
that would like L3 proto filtering.
I believe the changes required to make it work would also need to 
permeate into how searches are performed. Specifically it would need to 
include tuples with all possible l3protos when AF_UNSPEC is given, so we 
actually gather all entries regardless of l3proto. I believe that this 
is the intended behaviour, right?

Regards,
   Felix
