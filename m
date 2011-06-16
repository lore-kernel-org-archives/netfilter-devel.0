From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: FTP Packet Mangling & NAT
Date: Thu, 16 Jun 2011 13:04:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106161259580.1083@frira.zrqbmnf.qr>
References: <BANLkTintTA8T_FEqF-vWe85iTonfZHGn3w@mail.gmail.com> <81c0aab748c6ad27b289055e31777945@treenet.co.nz> <BANLkTim6WA1AW=ARNXKEx1kyVDo6TjCp-Q@mail.gmail.com> <4DF1E333.2060604@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nadeem Douba <ndouba@gmail.com>, netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40862 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab1FPLEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:04:40 -0400
In-Reply-To: <4DF1E333.2060604@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-06-10 11:26, Amos Jeffries wrote:
>
>Just to clarify; what I read you asking about was this scenario:
>When layer-7 software (proxy) does a NAPT mapping of text syntax
>IP1:port1 -> IP2:port2 sent out on IP3:port3 (proxy->server control
>control).
>  How to implement a layer-2 software (netfilter) to figure out this mapping
>and to do the reverse IP2:port2 -> IP1:port1 mapping on the text data inside
>the TCP packet body of packets returning on IP4:port4 (client->proxy control
>channel).
>So the packet flow is:
> control: client--nf_nat (DNAT/REDIRECT)-->proxy->server
> data:    client<--nf_nat (SNAT)----server
>
>Keep in mind that websense proxy terminates a TCP connection and generates a
>completely separate independent TCP connection from itself to the source
>server. Whether that is FTP origin or other proxy.
>
>So that the client->proxy information is in the INPUT tables.  The
>server->proxy response is in the OUTPUT tables.  And NAT is done in a third
>place the proxy normally does not have write access to.
>
>So to me those factors all mean layer-2 where netfilter modules operate is a
>very hard place to figure out what the correct mapping should be.

tl;dr. FTP has nothing to do with L2.

>(Jan, please correct me if you have some advanced magic voodoo that lets INPUT
>and OUTPUT chain connections link as RELATED state)

Why should it, your proxy seems to be creating a new set of logically
dinstinct connections.
