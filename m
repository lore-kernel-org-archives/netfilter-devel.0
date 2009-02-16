From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 18:22:33 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902161818350.26651@fbirervta.pbzchgretzou.qr>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <alpine.LSU.2.00.0902161804550.26651@fbirervta.pbzchgretzou.qr> <49999F85.2040405@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54751 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZBPRWe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:22:34 -0500
In-Reply-To: <49999F85.2040405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-16 18:16, Patrick McHardy wrote:
>>
>> Lowercasing targets was the original author's (Bart De Schuymer's)
>> deed ;-)
>>
>>[...]
>> Though, calling one of them =E2=80=9Cmark_m=E2=80=9D or underscore-s=
omething to avoid
>> the clash however, is what I dislike in favor of uppercasing target
>> names.
>
> Its actually just exposing an implementation detail of how match
> and target modules are located on the filesystem. The meaning
> (match or target) can be deduced from "-j" and "-m".
>
Too bad we cannot reasonably change it now.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
