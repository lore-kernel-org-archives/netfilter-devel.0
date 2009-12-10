From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: Fix compiler warning.
Date: Fri, 11 Dec 2009 00:23:40 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912110022440.10311@obet.zrqbmnf.qr>
References: <pvmein2bj1p.fsf@chavey.mtv.corp.google.com> <alpine.LSU.2.01.0912102301380.5189@obet.zrqbmnf.qr> <20091210.140843.142337259.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: chavey@google.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com,
	akpm@google.com
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20091210.140843.142337259.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Donnerstag 2009-12-10 23:08, David Miller wrote:
>> 
>>>Fix compiler warning "discards qualifiers from pointer target type",
>>>by allowing explicit discard of const qualifier thru type casting.
>>>The const_cast() macro is taken from a patch from Kaveh R. Ghazi
>> 
>> Uhm, I am not getting any warning on xt_time with either gcc-4.4.1
>> or gcc-4.5_20091126, so what case are we actually trying to fix?
>
>I get this warning with gcc-4.3.x all the time.

Ok. Still, assuming it was a "bug" which got fixed in gcc-4.4,
should we really bother with it anymore? (Thankfully it's just
a warning, and not an error.)
If so, we can probably do better code-wise.
