From: Pierre Rondou <prondou@gmail.com>
Subject: Re: EXPORT_SYMBOL missing in the kernel?
Date: Tue, 24 May 2011 17:42:53 +0200
Message-ID: <4DDBD1FD.1070203@gmail.com>
References: <4DDBACA6.2060501@gmail.com> <1306244451.3026.42.camel@edumazet-laptop> <4DDBB71D.6080205@gmail.com> <alpine.LNX.2.01.1105241639150.32028@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, evyncke@cisco.com,
	guy.leduc@ulg.ac.be, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:8966 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624Ab1EXPnH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 11:43:07 -0400
In-Reply-To: <alpine.LNX.2.01.1105241639150.32028@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jan,

I appreciate your help !

This problem is not related with the problem I had at this moment.

The "old" problem was about an output problem with ip6_local_out. I was=
=20
at this time on an old debian testing (between lenny and squeeze) and=20
the update to "complete" squeeze solved the problem, so I thought that=20
it was a problem related to my OS situation.

Now that you say that, I have realized that ip6_local_out (which I don'=
t=20
use anymore, I use ip6_output) was creating kernel panic when asked to=20
send an IPv6 packet with a size higher than the link mtu, should have=20
talked about it earlier though.

The little complain about NATIVI=20
(http://www.spinics.net/lists/netfilter-devel/msg18248.html) was that n=
o=20
kernel / Xtables developers told me they wanted the module inside the=20
kernel/Xtables or even sent me a remark about it and therefore could=20
take care about the missing "EXPORT_SYMBOL".
This module is developed inside Xtables and therefore doesn't need to=20
recompile a kernel.


While I'm sending you an e-mail, I may contribute to your very=20
interesting "Writing Netfilter modules" ebook.
I had to deal with checksums changes/update in both IPv4 and IPv6 and=20
may contribute to this section (5.7) if you still need someone to :-).

Regards,

Pierre

Le 24/05/11 16:41, Jan Engelhardt a =E9crit :
>
> On Tuesday 2011-05-24 15:48, Pierre Rondou wrote:
>   =20
>> Of course, the best way would be to patch the currently dev kernel (=
2.6.39 if I
>> take your word from previous mail) to use my module.
>> But I'm not a kernel developper and my previously proposed module (N=
ATIVI,
>> which had the same problem) didn't seem to get interest from kernel =
or Xtables
>> developers :(
>>     =20
> On the contrary. If there was no interest, I would not have written a
> reply. But you seem to have chosen to ignore that and went away with =
"it
> fixed itself".
>
> http://www.spinics.net/lists/netfilter-devel/msg18073.html
>   =20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
