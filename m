From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Fri, 18 Jul 2008 16:56:14 +0100
Message-ID: <1216396574.3568.6.camel@pumper.lan.luxnet.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>
	 <487F5874.3000905@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42003 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758921AbYGRP4X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:56:23 -0400
In-Reply-To: <487F5874.3000905@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The last message I accidentially first sent to Pablo only. He replied
without noticing that the list was missing. You find his reply included
in this message. (And I got it wrong with this message again, sorry for that.)

Pablo Neira Ayuso wrote:
> Fabian Hugelshofer wrote:
>> I started the application, sent 102'313 UDP packets with random source
>> ports and 1000B UDP payload in 57s (1795pps) and then waited until all
>> entries have been removed from the connection table. The CPU usage was
>> measured with top every 10s while sending and then averaged over 5
>> intervals. It was 56%, which seems quite high to me. Without any
>> applications running it is 11% to route this UDP traffic.
>>
>> The test application reports 113699 received events and 140 overflows.
>> The events are NEW and DESTROY events. Generally I would roughly expect
>> the double number of events than packets. Under this assumption 44% of
>> events have been dropped.
> 
> I guess that your device has little memory so the default socket buffer
> must be pretty small. I suggest you to increase the socket buffer size
> via nfnl_rcvbufsiz(), that will delay the ENOBUFS. I'd like to see the
> results with my suggestion.

The system has only 32MB of RAM. The default socket buffer size is
110592 bytes which applies to ctevtest. My real application increases
the socket buffer to 430080 bytes.

> Of course, this suggestion is not directly related with the message
> batching that you're proposing that can be useful to reduce CPU
> consumption - if someone wants to use ctevents for logging purposes
> which is what you want.

I increased the socket buffer size of ctevtest to 2MB. With this setting
no more overruns occur and all events can be logged (same test as
before). The CPU usage is now 84%.

I did not retest my real application yet, but the CPU usage will hit
100% again and the bigger buffer size will not help to prevent losses
anymore.



