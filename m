From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Thu, 15 Jan 2009 17:20:57 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901151720090.19363@fbirervta.pbzchgretzou.qr>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net> <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr> <496AEEB0.3080905@trash.net> <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
 <496F40DC.2000605@trash.net> <496F42F0.7050305@netfilter.org> <alpine.LSU.2.00.0901151651410.17559@fbirervta.pbzchgretzou.qr> <496F5C25.2010702@trash.net> <alpine.LSU.2.00.0901151658280.17559@fbirervta.pbzchgretzou.qr> <496F5E6C.3030703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51234 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348AbZAOQU6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:20:58 -0500
In-Reply-To: <496F5E6C.3030703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-15 17:03, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Thursday 2009-01-15 16:54, Patrick McHardy wrote:
>>>>> Agreed. The text-based interface seems to me like yet-another-interface
>>>>> that users may (ab)use (like /proc/net/nf_conntrack, I have seen people
>>>>> polling from it to display information, this was OK in the early days).
>>>>> Following this basis, one may come and implement another text-based
>>>>> interface to display the rule-set in the kernel and so on.
>>>> But is there an equivalent user tool and interface at this time
>>>> to obtain the same information?
>>> No that I know of, but that doesn't matter as long as nobody has a
>>> need for it.
>>>
>> As a developer of Xtables modules I have a need  ;-)
>
> That was one of my first thoughts, it looks mainly useful for
> developers. And I'm not very fond of the idea of adding almost
> 300 lines of segfile beauty for that.
>
Then you probably won't like it if I say that the same logic is
needed if I shall make the existing proc-files multi-nfproto aware.
