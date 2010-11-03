From: Justin Yaple <yaplej@gmail.com>
Subject: Re: libnetfilter_queue exiting on big tcp sessions
Date: Wed, 3 Nov 2010 12:51:54 -0700
Message-ID: <AANLkTi=j1ETKckuU_FXRE3srHD9egBdZ8XXqJP=hkdxE@mail.gmail.com>
References: <AANLkTimmr4MVCOwgxea9KoGB1BjomBchJ7oAgpnt2WyZ@mail.gmail.com>
	<AANLkTin_ZFeXkzJ6zELpX3pP3782YfLjHcPzHrjDt1Ae@mail.gmail.com>
	<AANLkTikV4_MD0JZzbvKhSXjL-abMDY7Af_3FTbbTzP33@mail.gmail.com>
	<AANLkTikRXtjo-0y9aAPmOQ_gAWfTAYM4D-eDfTwah8z6@mail.gmail.com>
	<AANLkTikxw3dyv6SUVo4O36sHhVM+eZfgb1A5sX-tCM1b@mail.gmail.com>
	<AANLkTinQ6Q3B7XbdaCRJ9Qr0bTf6VGjLVkjgUtXaSjjk@mail.gmail.com>
	<AANLkTin9DYRgeCNzkoxDS6Yy1pJ_jdPdzo0VDFe3S9q_@mail.gmail.com>
	<1288810531.2511.237.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mistick Levi <gmistick@gmail.com>,
	Rajkumar S <rajkumars@gmail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38070 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab0KCTwF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:52:05 -0400
In-Reply-To: <1288810531.2511.237.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 3, 2010 at 11:55 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> If this is running on multi processor machine, you could use several NF
> queues (one per cpu).
I dont know if it would make much of a difference for my application.
Either way the kernel is going to be capable of receiving more traffic
than the application can handle but my application is not meant to
process traffic from high bandwidth connections.  Its designed to
increase performance of low speed WAN connections.  If the virtual
machines are able to handle ~20Mb then thats multiple DS1s right
there.

> Eventually also use RPS if your network card is not multiqueue, to
> spread tcp flows to different cpus and different queues.
I am doing this currently inside the application.  I have read some
papers on using multiple queues for sniffing high-speed circuits but
my application is doing compression, disk IO and eventually
application layer specific processing on the payload of every TCP
segment for each session.  I dont expect that all to happen at 1Gbps.

I would be quite happy if I can get a single system able to handle a
DS3 worth of optimized TCP traffic and extremely happy if I can get an
OC3 worth.  I know without a doubt that my current bottleneck is the
host system.  Running the iperf tests causes near 100% CPU usage on
the host system and the VMs are near ~60% on each of their virtual
CPUs.  Now that the issue with the queue is resolved I will go back to
testing on physical hardware to see what results I get.

The final goal is something similar to the commercially avaliable WAN
accelerators and none of them offer single system solutions for
greater than DS3 connections that I am aware of.  I need to determine
the number of TCP sessions that a single system with a given ammount
of memory for the buffer.  This very issue might be why the commercial
product vendors ask questions about number of users and active TCP
sessions in their planning guides.
