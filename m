From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Thu, 17 Jul 2008 15:34:28 +0100
Message-ID: <487F5874.3000905@gmx.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58211 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758822AbYGQOe3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:34:29 -0400
In-Reply-To: <487F18DA.7030208@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Fabian Hugelshofer wrote:
>> I am writing a network application for a genuine wireless router (266Mhz
>> IXP4XX). I am capturing packets with ULOG and need connection tracking.
>> For performance reasons I planned to use connection tracking events
>> (NEW/DESTROY) to avoid doing the same work twice.
> 
> Did you write your own application to handle ctevents and ULOG messages?
> Are you using any library? What does your application do?

I am using:
libnetfilter_conntrack 0.0.89
libnfnetlink 0.0.38
libipulog (from ulog2 r6382)

My application parses packets (IP and transport headers) and increments 
different counters per sending host. For this a hash table lookup is 
performed. Similar for ctevents.


> We now have the berkeley socket filtering facilities for netlink, you
> may use it to filter only the events that you need. I have a patch here
> for libnetfilter_conntrack that introduces a high-level API to
> autogenerate simple BSF code for filtering. As soon as I finish testing
> it, I'll commit it.

This is interesting and useful in various cases. Thanks for 
implementing. However, here I does not help, as I need all events.


> Also, you may periodically dump the connection tracking table (polling),
> but, of course, this depends on the nature of your application. Assuming
> that your application is a logger, this is not a choice as you'll lose
> information.

Polling is not possible as I need destroy events and information in 
them. Further I don't want to loose any events.


>> In a high load test case I stress the router with UDP packets with
>> random source ports (1000B payload, 1800pps). CPU usage is 100%, 10% of
>> packets and 80% ctevents are dropped. If I disable ctevents, the CPU
>> usage is just 24% and no packet drops occur.
> 
> I have a similar testbed here. You did not mention the threshold that
> you're using in ULOG. If you provide more information on your
> application I'll try to reproduce those numbers.

--ulog-cprange 96 --ulog-qthreshold 50

A dispatcher is calling back a ulog and a ctevent module as soon as 
their sockets are readable. The modules then read one message from the 
socket and process it before returning to the dispatcher. If both 
sockets are readable at the same time, both modules are called back.

To reduce any side effects I wrote a small test application which just 
reads the ctevent socket and does nothing else. You find it attached to 
this email.

I started the application, sent 102'313 UDP packets with random source 
ports and 1000B UDP payload in 57s (1795pps) and then waited until all 
entries have been removed from the connection table. The CPU usage was 
measured with top every 10s while sending and then averaged over 5 
intervals. It was 56%, which seems quite high to me. Without any 
applications running it is 11% to route this UDP traffic.

The test application reports 113699 received events and 140 overflows. 
The events are NEW and DESTROY events. Generally I would roughly expect 
the double number of events than packets. Under this assumption 44% of 
events have been dropped.

As I wrote earlier my real application is easily able to capture and 
process packets from this traffic flow without any drops and 24% CPU 
usage, as long as I unload nf_conntrack_netlink or do not initialise my 
ctevent module. If ctevents are used it is reasonable that more events 
are lost than with the test application as no events are read as long as 
a multipart ulog message is processed. However 44% drops with the test 
app seems too high. I think that either ctevents are very expensive in 
general or a big overhead is introduced by passing them one at the time.


>> Do you think introducing multipart messages for connection tracking
>> events is feasible without breaking existing applications? Maybe with a
>> default setting of 1 bundled events, which can be increased by a
>> function call?
> 
> AFAIK, libnfnetlink and other netlink-based libraries should handle the
> multipart messages appropriately so that should not be a problem.
> 
>> Is someone intending to implement multipart messages for ctevents? ;-)
> 
> The problem here is that batching should be a per-socket parameter. We
> will not accept a patch that changes the behaviour for all the ctevent
> users. And I don't see an obvious way to do this now.

If you do see a good way to do it, let me know. Depending on how much 
time I have I might consider implementing it.


Fabian


Example top for ctevtest:
Cpu(s):  0.1%us,  3.1%sy,  0.0%ni, 38.8%id,  0.0%wa,  1.4%hi, 56.6%si, 
0.0%st
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  3913 root      20   0   696  220  160 R 32.1  0.7   0:03.89 ctevtest
  3916 root      20   0  1068  548  412 R  0.8  1.8   0:00.22 top
