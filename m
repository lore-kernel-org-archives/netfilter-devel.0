Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C0AC31E40
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 23:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BE7F20644
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 23:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Jz774Ohd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfGMXZ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 19:25:27 -0400
Received: from mx1.riseup.net ([198.252.153.129]:45294 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbfGMXZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 19:25:26 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 1953C1A0ED7;
        Sat, 13 Jul 2019 16:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563060326; bh=DmKUYaoUOM86z5LuxVprF96UxP1G3RxeHz/XUnsu2fw=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=Jz774Ohd3CpmTBuZLe7oYr2pKZWYrh1k+eehY8EwKdDmyTYyUswaSy5QbzLs1U1Yc
         khW7gvAkVR+E3iIvpMah8Dh2ADYomKYERKWtqgMkHidFPItRKuZXAW7xR8rhiTR0Wu
         W+V8ZvsY22nJc8RqJhPQaGpXs2iHoMsBKsap63gs=
X-Riseup-User-ID: 377415439136E410343BCE5070E96B528CE2FEAE07DF0BBDF107A30CA93FCF5E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 7D321222430;
        Sat, 13 Jul 2019 16:25:25 -0700 (PDT)
Date:   Sun, 14 Jul 2019 01:25:19 +0200
In-Reply-To: <20190713222624.heea2xjqeh52dohu@breakpoint.cc>
References: <20190712104513.11683-1-ffmancera@riseup.net> <20190713222624.heea2xjqeh52dohu@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nf v2] netfilter: synproxy: fix rst sequence number mismatch
To:     Florian Westphal <fw@strlen.de>
CC:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <D18A40D8-9569-4975-8CC2-3ED9DE7FFFB7@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 14 de julio de 2019 0:26:24 CEST, Florian Westphal <fw@strlen=2Ede> escr=
ibi=C3=B3:
>Fernando Fernandez Mancera <ffmancera@riseup=2Enet> wrote:
>> 14:51:00=2E024418 IP 192=2E168=2E122=2E1=2E41462 > netfilter=2E90: Flag=
s [S], seq
>> 4023580551, win 64240, options [mss 1460,sackOK,TS val 2149563785 ecr
>> 0,nop,wscale 7], length 0
>
>Could you please trim this down to the relevant parts
>and add a more human-readable description as to where the problem is,
>under which circumstances this happens and why the
>!SEEN_REPLY_BIT test is bogus?
>
>Keep in mind that you know more about synproxy than I do, so its
>harder for me to follow what you're doing when the commit message
>consists
>of tcpdump output=2E
>
>> 14:51:00=2E024454 IP netfilter=2E90 > 192=2E168=2E122=2E1=2E41462: Flag=
s [S=2E],
>seq
>> 727560212, ack 4023580552, win 0, options [mss 1460,sackOK,TS val
>355031 ecr
>> 2149563785,nop,wscale 7], length 0
>> 14:51:00=2E024524 IP 192=2E168=2E122=2E1=2E41462 > netfilter=2E90: Flag=
s [=2E], ack
>1, win
>> 502, options [nop,nop,TS val 2149563785 ecr 355031], length 0
>> 14:51:00=2E024550 IP netfilter=2E90 > 192=2E168=2E122=2E1=2E41462: Flag=
s [R=2E],
>seq
>> 3567407084, ack 1, win 0, length 0
>
>=2E=2E=2E its not obvious to me why a reset is generated here in first pl=
ace,
>and why changing code in TCP_CLOSE case helps?
>(I could guess the hook was called in postrouting and close transition
> came from rst that was sent, but that still doesn't explain why it
> was sent to begin with)=2E
>
>I assume the hostname "netfilter" is the synproxy machine, and
>192=2E168=2E122=2E1 is a client we're proxying for, right?

Sure, I will prepare a detailed description of the problem=2E Sorry about =
that and thanks!
