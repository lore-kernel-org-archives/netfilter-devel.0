From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Throughput test for kernelspace module vs. userspace daemon with
 strange results
Date: Fri, 11 Apr 2008 15:10:23 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804111509140.21182@fbirervta.pbzchgretzou.qr>
References: <47FF613C.4010701@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Mader <thezema@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43950 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYDKNKY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:10:24 -0400
In-Reply-To: <47FF613C.4010701@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-04-11 15:01, Thomas Mader wrote:
>
> I have two programs with a similar task. One is implemented as a kernelspace
> module and the other as a userspace daemon using libnetfilter_queue.
> Bot work with the same algorithm and inspect udp packets, send icmp packets on
> special events and receive icmp replys.
> I did a throughput test for both the following way:
>
> On my laptop I start the module/daemon and start a netperf udp stream from my
> laptop to a server on LAN. The module/daemon inspect the udp stream and does
> it's work. When the test is over, netperf shows me the throughput which came
> through to the server.
> Without any module/daemon running I get ~95mbit/s for my 100mbit LAN.
> The funny thing though is, that I get ~85mbit/s with my kernelspace module but
> ~90mbit/s with my userspace daemon.
>
> I thought about explanations for this but I don't come to reasonable
> explanations for this behaviour. Shouldn't the kernelspace module be faster?
> Why is it slower?

You are using a raw socket in userspace, which effectively
bypasses Netfilter.
To make a meaningful test of it, the PF_RAW code would need
an NF_HOOK into iptables to make a more accurate comparison I think.
