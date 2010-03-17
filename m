From: Dominik Kaspar <dokaspar.ietf@gmail.com>
Subject: Re: RAWDNAT and disappearing packets
Date: Wed, 17 Mar 2010 15:08:33 +0100
Message-ID: <2a3692de1003170708y1d4603beh895d85f82e94ecc2@mail.gmail.com>
References: <2a3692de1003170240k1b5b4e88k6f447d8fd3cb213@mail.gmail.com>
	 <alpine.LSU.2.01.1003171323240.2731@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:56996 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0CQOIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:08:35 -0400
Received: by bwz4 with SMTP id 4so1064444bwz.39
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2010 07:08:34 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1003171323240.2731@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Thanks for your quick response.
Disabling the rp_filter made everything work!

Agreed, disabling the rp_filter is not a very secure and elegant
solution. At least I have a working solution now. But what exactly did
you mean by "proper policy routing" when saying that NAT should not be
used for asymmetric routing?

Greetings,
Dominik


On Wed, Mar 17, 2010 at 1:28 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Wednesday 2010-03-17 10:40, Dominik Kaspar wrote:
>>
>>I have a question about why packets are disappearing in my setup. My
>>machine has two L2TP tunnels (10.6.1.2 and 10.6.1.3) to a Web server
>>(10.6.1.1). The local machine uses a command such as "wget
>>http://10.6.1.1/file --bind-address 10.6.1.2" to request a file from
>>the server. On the server, outgoing packets are rewritten to 10.6.1.3,
>>so that they travel back through the other tunnel. That works fine.
>
> For asymmetric routing, you should not be using NAT, but proper
> policy routing.
>
>>At the client, I am using the RAWDNAT target to translate the address
>>of incoming packets destined for 10.6.1.3 to be locally translated
>>back to 10.6.1.2. This is the rule I use:
>>
>>iptables -t raw -A PREROUTING -p tcp --sport 80 -d 10.6.1.3 -j RAWDNAT
>>--to-destination 10.6.1.2
>
> That might trip up rp_filter.
>
>>According to the netfilter flow chart, a packet then travels into
>>"conntrack" and then into MANGLE PREROUTING, where I can still log the
>>packet (that is now going to 10.6.1.2 instead of 10.6.1.3).
>>
>>However, then it somehow disappears! I cannot find the packet in NAT
>>PREROUTING and also not in any INPUT or FORWARD tables after the
>>routing decision point. What happened? What made the packet suddenly
>>disappear? Is there something going on that causes the packets to be
>>dropped?
>
> My guess is that route lookup failed, or rp_filter.
> Unfortunately I don't know a way to make failed route lookups
> visible - perhaps the iproute2 guys have a magic command?
>
