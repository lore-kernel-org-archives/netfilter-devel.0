From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 13:20:59 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805151318390.16151@fbirervta.pbzchgretzou.qr>
References: <200805151421.23862.anton.vazir@gmail.com> <20080515093413.GC3442@khasse.inl.fr> <200805151604.44874.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Leblond <eric@inl.fr>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38437 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYEOLVA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 07:21:00 -0400
In-Reply-To: <200805151604.44874.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-15 13:04, Anton wrote:
>>
>> If you plan to use mark for QOS or routing why not simply
>> use native classifier of tc or "ip rule" ?
>
>Jan meant the exact case, I'm using this for shaper, so I 
>would need to remake scripts to use IPMARK... hopefully it 
>can also match networks... but this will give inflexibility 
>in many cases, like ports

IPMARK is a target so it itself does not deal with matching;
but if you meant marking network, well than nothing easier than that:
(pick one)

(a) -j IPMARK --and-mask 0xffffff00  (for a /24)
(b) -j IPMARK; -j MARK --and-mark 0xffffff00;

Now since you are concerned about speed I guess the former is what you want.
Perhaps varying (a) to not leave the 8 null bits:

(c) -j IPMARK --shift 8
