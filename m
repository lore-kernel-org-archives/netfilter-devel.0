From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Fri, 16 Jan 2009 09:14:14 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901160901090.22357@fbirervta.pbzchgretzou.qr>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net> <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr> <496AEEB0.3080905@trash.net> <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
 <496F40DC.2000605@trash.net> <496F42F0.7050305@netfilter.org> <alpine.LSU.2.00.0901151651410.17559@fbirervta.pbzchgretzou.qr> <496F5C25.2010702@trash.net> <alpine.LSU.2.00.0901151658280.17559@fbirervta.pbzchgretzou.qr> <496F5E6C.3030703@trash.net>
 <alpine.LSU.2.00.0901151720090.19363@fbirervta.pbzchgretzou.qr> <4970385B.3000209@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50027 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZAPIOQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:14:16 -0500
In-Reply-To: <4970385B.3000209@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-01-16 08:33, Patrick McHardy wrote:
>>>> As a developer of Xtables modules I have a need  ;-)
>>> That was one of my first thoughts, it looks mainly useful for
>>> developers. And I'm not very fond of the idea of adding almost
>>> 300 lines of segfile beauty for that.
>>>
>> Then you probably won't like it if I say that the same logic is
>> needed if I shall make the existing proc-files multi-nfproto aware.
>
> What does "multi-nfproto aware" mean exactly?

The thing is, /proc/net/ip_tables_matches's seq_start function takes
the lock, lets it iterate, and drops the lock on seq_stop. That is
easy for a single list (xt[af].match), but when you want to make
matches from more than just one nfproto visible in that file, you
need to drop the lock during seq_next, and acquire the next one too.
Not only that, but you also have to switch the list you are
traversing, which is currently conveniently passed through the "v"
variable. And you need to keep track of the nfproto whose list you
are iterating through, because seq_stop can be called with either one
currently being traversed.
