Return-Path: <SRS0=9Oxv=6H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE76DC54FD0
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Apr 2020 14:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6E2B20857
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Apr 2020 14:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=newquest.fr header.i=@newquest.fr header.b="7h9XBkQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgDWOM6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:12:58 -0400
Received: from relay.newquest.fr ([51.77.151.64]:48548 "EHLO relay.newquest.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbgDWOM6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Apr 2020 10:12:58 -0400
Received: from webmail.newquest.fr (mail2.newquest.fr [89.90.209.189])
        by relay.newquest.fr (8.14.7/8.14.7) with ESMTP id 03NECtxd015477
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 16:12:55 +0200
Received: from webmail.newquest.fr (localhost [127.0.0.1])
        by webmail.newquest.fr (Postfix) with ESMTPS id 50C1EEA0432
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 16:12:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by webmail.newquest.fr (Postfix) with ESMTP id 36D0AEA0427
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 16:12:55 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 webmail.newquest.fr 36D0AEA0427
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=newquest.fr;
        s=nqdkim; t=1587651175;
        bh=rx4KRvxm7KYegLqerZGR/kQcXFSyt0VHhQjdV/Ma948=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=7h9XBkQINoJwToXpJxCU7pqWVwjqn76rddVosQiUpFuSzY0a5Db52Ea4Z7PedB8Vo
         uZ10ZSWySxKQhfDMqmEZL0aEGCRiFOkjr+Cyp2HYdA8CGbuRJPxFf6qU7PunoTPwOM
         sjonEeTmDZpuBMz07wAoOl0ZPx5r0ZqMe5G7uPXQmNnSRwahRfNy4w7r06BjHPrpOV
         8KXvhoWONlzTJpL9i6/DF1DXL+zFC3gmN7V1rm2UEp2uJEwntMzQmCARFa4sKHtYuu
         bNtmMQdbKIQZJARjorc/vVo12iS903hIptNDcu/CjceZfiBEfNtvRT73wRDt8RNlP/
         JZ5yVzKHaippA==
Received: from webmail.newquest.fr ([127.0.0.1])
        by localhost (webmail.newquest.fr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HN80gKj2v6gl for <netfilter-devel@vger.kernel.org>;
        Thu, 23 Apr 2020 16:12:55 +0200 (CEST)
Received: from [172.16.0.14] (gateway [192.168.0.254])
        by webmail.newquest.fr (Postfix) with ESMTPSA id 112CAEA03D8
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 16:12:55 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
From:   Milan JEANTON <m.jeanton@newquest.fr>
Subject: Problem with flushing nftalbes sets
Message-ID: <5a20c054-cf2e-9694-2242-03e1d01cf568@newquest.fr>
Date:   Thu, 23 Apr 2020 16:12:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I try to send you the message again, it says it couldn't be send because=20
it was an HTML type message.


I use nftables for a development project with our company and I'm happy=20
with this application but I'm still learning a lot with all the options.

I'm using Debian environments (stretch and buster).

My problem is with the sets of nftables:
I use the sets to manage a large amount of ip addresses since it store=20
only the ipv4 addresses without any rules and process it much quicker.

So let's say I have this table configuration:

table ip test {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set tmp {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 type ipv4_addr
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
}

I can add elements in my set without any problem, I can also delete them=20
one by one.

The problem I have is that I need to delete all the elements in the tmp=20
set and as precised in the manual of nftables I could flush the elements=20
of a set:

SETS
[...]
flush=C2=A0=C2=A0=C2=A0 Remove all elements from the specified set.

But when I use the command to flush my sets, it doesn't work and=20
displays me an error message

nft 'flush set test tmp'
Error: Could not process rule: Invalid argument
flush set test tmp
^^^^^^^^^^^^^^^^^^^

So I used an other method that worked on version 0.7 by selecting all=20
the content of elements, but I updated to version 0.9.4 and can't make=20
it work since there is a new line each two addresses and I would rather=20
use a native command anyway.

I don't understand what I do wrong ? If you can please help me.

Regards,
