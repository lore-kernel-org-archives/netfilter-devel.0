From: Ed W <lists@wildgooses.com>
Subject: Re: Reg:Conntrack-tool for packet dropping?
Date: Tue, 04 Oct 2011 19:34:18 +0100
Message-ID: <4E8B51AA.7030107@wildgooses.com>
References: <CAAG0ft6yyx+PzcvxpfsnCTok7U+cdx3mnsU4gyJMk=zqCOn45A@mail.gmail.com> <CAAG0ft4=CaBsdVxKApmvaBhP06xr+1522=Xcwo9O_59zSWunBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Manikandan R <mani.agape@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:34931 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab1JDSnc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:43:32 -0400
In-Reply-To: <CAAG0ft4=CaBsdVxKApmvaBhP06xr+1522=Xcwo9O_59zSWunBA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/10/2011 15:09, Manikandan R wrote:
>  Hi,
>     I am developing application monitoring tool. When I gothru
> http://netfilter.org/, I come to know about the conntrack-tool which
> can be used for monitoring new connection.
>     I used "conntrackd"(conntrack deamon) for monitoring the packets.
> Using nfct_callback_register2() am able to handle new packets also,
> but I need to drop this packet if its related to particular
> pid/process. Is there is any way/api to drop packets?
>

Conntrack doesn't quite track all packets - see my previous questions
about this...

I think also if you need to examine all packets and decide their fate
ahead of allowing them through then you need to look at userspace queue
stuff?

Note you can setup some extremely clever filtering using iptables. That
has the ability to filter based on local user id, possibly process id
and also your app can set firewall marks on each packet that can be
easily filtered on later?

Good luck

Ed E
