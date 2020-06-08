Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B36FC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 10:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203F3206A4
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 10:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=openfortress.nl header.i=rick@openfortress.nl header.b="XnP2q32q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgFHKCc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 06:02:32 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:51173 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729240AbgFHKCb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 06:02:31 -0400
Received: from popmini.vanrein.org ([IPv6:2001:980:93a5:1::7])
        by smtp-cloud7.xs4all.net with ESMTP
        id iEbsjMBktNp2ziEbtja6e6; Mon, 08 Jun 2020 12:02:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openfortress.nl; 
 i=rick@openfortress.nl; q=dns/txt; s=fame; t=1591610547; 
 h=message-id : date : from : mime-version : to : cc : 
 subject : references : in-reply-to : content-type : 
 content-transfer-encoding : date : from : subject; 
 bh=xvpg3Lh1Iz/oJRGK1+PGCzVuHGyg+C5cu+FysPz5ImE=; 
 b=XnP2q32qhcj+7BTw8oqoWHvkS7Z3+vSH1q64TkRiBj4U2DYv9Ni+btAH
 O6/kalJJsRk/qFi8Ll4POLi0qmdzuQyGq4LKtRLMp/39ch+uSG/evcWm+o
 nOdRHRoVrNltW5JuLBy2V8BIqp8A2yxWlHdk71dCadHOYJPMume4yNUxk=
Received: by fame.vanrein.org (Postfix, from userid 1006)
        id DC63A3CF75; Mon,  8 Jun 2020 10:02:27 +0000 (UTC)
Received: from airhead.fritz.box (phantom.vanrein.org [83.161.146.46])
        by fame.vanrein.org (Postfix) with ESMTPA id AED963CF73;
        Mon,  8 Jun 2020 10:02:24 +0000 (UTC)
Message-ID: <5EDE0C9B.2020701@openfortress.nl>
Date:   Mon, 08 Jun 2020 12:02:03 +0200
From:   Rick van Rein <rick@openfortress.nl>
User-Agent: Postbox 3.0.11 (Macintosh/20140602)
MIME-Version: 1.0
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     netfilter-devel@vger.kernel.org
Subject: Re: Expressive limitation: (daddr,dport) <--> (daddr',dport')
References: <5EDC7662.1070002@openfortress.nl> <20200607220810.GA6604@salvia>
In-Reply-To: <20200607220810.GA6604@salvia>
X-Enigmail-Version: 1.2.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.520000, version=1.2.4
X-CMAE-Envelope: MS4wfKk9AYjZB7aCxfD2VxaV3T3A/xnPNt29egzRLAWG0heZtjDuNm8yRTWZLh8YkEW9E0ogZ3vQFZPPd/LwFIKGfBaeHmNfUMjuaHi2gv1V+Ez4IEbrCbht
 G8gaz/wZyH7W+6RE9LMT0uYxnkqixIDs0kEtYcgxVWxLKbjONXC9t2speLWsToTIEd9mfusCLXcrK8QWv8ca1r8G3XJpByrxRFY=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo / NFT-dev,

>> This is bound to work in many cases, but it can give undesired
>> crossover behaviours [namely between incoming IPs if they map to the
>> same daddr' while coming from the same dport]:
>>
>> nft add rule ip6 raw prerouting \
>>    ip6 daddr set \
>>       ip6 daddr . tcp dport \
>>          map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
>>    tcp dport set \
>>       ip6 daddr . tcp dport \
>>          map { $PREFIX::100:20 . 8080 : 80 } \
> 
> So, you would consolidate this in one single rule? So there is one
> single lookup to obtain the IP address and the destination port for
> the stateless packet mangling.

It already is a single rule, but a single mapping, or one that appears
like one.  In reality, I use dynamic map @refs, of course.

A single lookup would avoid the problem that the key has changed in the
second lookup.

I played around, trying if I could "ip6 daddr . tcp dport set" and
perhaps have a map with elements like "{ $PREFIX::64:75 . 8080 :
$PREFIX::100:20 . 80 }" but did not find a syntax.  [I've been missing a
formal syntax, it's all examples so I wasn't sure if this was possible
at all.]  It'd look like

new_nft add rule ip6 raw prerouting \
   ip6 daddr . tcp dport set \
      ip6 daddr . tcp dport \
         map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 . 80 }


>>  0. Is there a way to use maps as atomic setter for (daddr,dport)?
> 
> Not yet.

Ah, you spotted the problem too.  No surprise ;-)

>>  1. Can I reach back to the original value of a just-modified value?
> 
> You mean, the original header field that was just mangled? Like
> matching on the former IP address before the mangling?

Yes, exactly.  That way, I can use two maps but find the right
combination of addr/port without intermediate key changes.

>>  2. Is there a variable, or stack, to prepare with the old value?
> 
> But this is to achieve the atomic mangling that you describe above or
> you have something else in mind? You would like to store the former IP
> daddr in some scratchpad area that can be accessed later on, right?

It is another possible way to get to the old value so I can make the
same mapping.

I could imagine storing the old daddr in daddr2 then mapping daddr and
using daddr2 in the second map looking to find the matching port.  That
might look like

new_nft add rule ip6 raw prerouting \
   rulevar set ip6 daddr \
   ip6 daddr set \
      ip6 daddr . tcp dport \
         map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
   tcp dport set \
      rulevar . tcp dport \
         map { $PREFIX::100:20 . 8080 : 80 } \

If the language internally uses a stack, I could imagine pushing the old
value(s) to prepare for the second map, then perform the first map and
continue with the second.  That might look like

new_nft add rule ip6 raw prerouting \
   ip6 daddr push \
   ip6 daddr set \
      ip6 daddr . tcp dport \
         map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
   tcp dport set \
      pop . tcp dport \
         map { $PREFIX::100:20 . 8080 : 80 } \


The examples are just three syntaxes I can think of.


Thanks,
 -Rick
