From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add locking for counters zeroing
Date: Wed, 24 Sep 2008 18:57:10 +0200
Message-ID: <48DA7166.6070408@trash.net>
References: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl> <48DA643C.5000702@trash.net> <alpine.LNX.1.10.0809241206030.16193@fbirervta.pbzchgretzou.qr> <48DA66BE.6090209@trash.net> <alpine.LNX.1.10.0809241226020.16193@fbirervta.pbzchgretzou.qr> <48DA6E01.2020101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42403 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXQ5f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:57:35 -0400
In-Reply-To: <48DA6E01.2020101@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>
>> Of course. You still have to add the spin_lock, preferably outside of 
>> the loop
>> so it does not get necessarily dropped/re-picked-up.
>
> Yes, but even more preferrably is don't huring normal dumps for 
> counter zeroing.
-EUNPARSABLE :)

It meant to say: "even more preferrably it shouldn't hurt normal dumps".


> So I think we should split the operations. 

