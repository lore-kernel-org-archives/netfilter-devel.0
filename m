From: Pierre Rondou <prondou@gmail.com>
Subject: Re: EXPORT_SYMBOL missing in the kernel?
Date: Wed, 25 May 2011 15:05:22 +0200
Message-ID: <4DDCFE92.1040003@gmail.com>
References: <4DDBACA6.2060501@gmail.com> <1306244451.3026.42.camel@edumazet-laptop> <4DDBB71D.6080205@gmail.com> <alpine.LNX.2.01.1105241639150.32028@frira.zrqbmnf.qr> <4DDBD1FD.1070203@gmail.com> <alpine.LNX.2.01.1105242323290.2691@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, evyncke@cisco.com,
	guy.leduc@ulg.ac.be, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:41650 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757855Ab1EYNFX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 09:05:23 -0400
In-Reply-To: <alpine.LNX.2.01.1105242323290.2691@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 24/05/11 23:32, Jan Engelhardt a =E9crit :
> On Tuesday 2011-05-24 17:42, Pierre Rondou wrote:
>   =20
>> The little complain about NATIVI
>> (http://www.spinics.net/lists/netfilter-devel/msg18248.html) was
>> that no kernel/Xtables developers told me they wanted the module
>> inside the kernel/Xtables
>>     =20
> But they did not say "don't want" either :)
>
> Sorry, I must have skipped over that mail somehow. It's still in
> my inbox, so that means the topic had not been closed.
>
> The only other "excuse" I can give is that, on a closer look now, the
> mail did not contain a merge request, just an offer for help.
> (Wording: "If you believe that this module can be included is the
> Linux Kernel or in the Xtables-addons framework, I'll be glad and
> will help you in this task.")
>
> If you, or somebody else, wants to have it merged, in either the
> kernel or Xtables-addons, please send in a patch, and we will discuss
> it from there on.
>   =20

Ok, I didn't know how adding kernel functionalities works actually...
I'll propose a patch to get it added on current dev kernel a bit later=20
(gotta finish writing my thesis first).

>   =20
>> While I'm sending you an e-mail, I may contribute to your very inter=
esting
>> "Writing Netfilter modules" ebook.
>>     =20
> If you replace .pdf in the URL by .lyx, you can get at the source
> of the document and make a patch against that if you like.
> Other ways to convey your additions are also acceptable - it
> is not required to be diff.
>   =20

Ok, I'll send you a patch or something like that after I finished the=20
writing of my thesis.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
