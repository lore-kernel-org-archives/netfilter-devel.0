From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Possible iptables 4.4.11 issues
Date: Tue, 31 May 2011 11:51:45 +0200
Message-ID: <BANLkTikKCG1O3MPY66J1omnOQF+QPf-NJw@mail.gmail.com>
References: <4DE2593E.7000208@shorewall.net>
	<alpine.LNX.2.01.1105291647200.26223@frira.zrqbmnf.qr>
	<4DE4B7EE.9060107@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Tom Eastep <teastep@shorewall.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Steven Jan Springl <steven@springl.ukfsn.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54804 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1EaJvq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 05:51:46 -0400
Received: by pvg12 with SMTP id 12so1946946pvg.19
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2011 02:51:45 -0700 (PDT)
In-Reply-To: <4DE4B7EE.9060107@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>> -A OUTPUT -p 6 --dport 888 -o eth1 -j IPMARK --addr
>>> dst --and-mask -1 --or-mask -64 --shift 0
>>> After upgrading to iptables 1.4.11 the following iptables-restore error is
>>> produced:
>>>
>>> iptables-restore v1.4.11: IPMARK: Bad value for "and-mask" option: "-1"
>>
>> This is intentional. Bitwise operations work best when fed unsigned numbers
>> only.
>
> but this used to work, we shouldn't break this sort of things Jan.

Assuming 2's complement arithmetic, an --and-mask of -1 should be a no-op
(since -1 is all 1's in binary)

However when reading --and-mask -1 my first gut instinct is that this
is --and-mask ~1 and is thus clears the least significant bit.
I also instinctively incorrectly assume --or-mask -64 sets all but bit
6, when it is actually setting all but the bottom 6 bits (ie. bits 0
through 5)...

To me this sort of lack of clarity is undesirable, and I can certainly
understand the desire to disable masks with negative integers.

-- Maciej
