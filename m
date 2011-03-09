From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_queue: Some accepted packets get lost
Date: Wed, 09 Mar 2011 14:44:18 +0100
Message-ID: <4D778432.10802@netfilter.org>
References: <4D716FFE.8050503@jetable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Fabien C." <7o5fzvj4duxjxzp@jetable.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab1CINoY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:44:24 -0500
In-Reply-To: <4D716FFE.8050503@jetable.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/03/11 00:04, Fabien C. wrote:
> Hello list,
> 
> I ran into a strange behavior lately using libnetfilter_queue: in some specific
> conditions, accepted queued paquet would in fact be lost. I am having the
> problem on a custom 2.6.37.2 kernel, but not on the official Debian Squeeze
> kernel (2.6.32-5).
> 
> The code I use is very similar to the test code available on the netfilter
> website
> (http://www.netfilter.org/projects/libnetfilter_queue/doxygen/nfqnl__test_8c_source.html),
> accepting every queued packet.
> 
> I am queuing outgoing DNS requests with the following rule:
>  iptables -A OUTPUT -p udp --dport 53 -j NFQUEUE --queue-num 666
> 
> Then, launch a browser (tested with Firefox 3.5 and Chromium 9), type a URL,
> the browser hangs for 5 seconds and then displays the webpage. So I ran tcpdump
> and the queue program on the same terminal. See what happens with and without
> the NFQUEUE rule:
> 
> 
> * Normal behavior, iptables are empty (tcpdump - real domain and ip modified):
> 
> 13:29:21.630530 IP 10.3.5.8.38047 > 10.3.5.1.53: 41247+ A? www.mydomain.net. (35)
> 13:29:21.630563 IP 10.3.5.8.38047 > 10.3.5.1.53: 12691+ AAAA? www.mydomain.net.(35)
> 13:29:21.631170 IP 10.3.5.1.53 > 10.3.5.8.38047: 41247 1/3/3 A 12.34.123.210 (157)
> 13:29:21.774174 IP 10.3.5.1.53 > 10.3.5.8.38047: 12691 0/1/0 (94)
> 
> 
> * Using a queue ('tcpdump -ni eth0 udp port 53' and queue manager on the same
> terminal):
> 
> 01) 20:08:00.486366: recv returned 108
> 02) 20:08:00.486566: setting verdict : accept the packet...
> 03) 20:08:00.486614 IP 10.3.5.8.46938 > 10.3.5.1.53: 51146+ A? www.mydomain.net. (35)
> 04) 20:08:00.487193 IP 10.3.5.1.53 > 10.3.5.8.46938: 51146 1/3/3 A 12.34.123.210 (157)
> 05) 20:08:00.586723: recv returned 108
> 06) 20:08:00.586789: setting verdict : accept the packet...
>  [==> tcpdump doesn't see this one - so browser waits for 5sec, and retries]
> 07) 20:08:05.490419: recv returned 108
> 08) 20:08:05.490479: setting verdict : accept the packet...
> 09) 20:08:05.490518 IP 10.3.5.8.46938 > 10.3.5.1.53: 51146+ A? www.mydomain.net. (35)
> 10) 20:08:05.490990 IP 10.3.5.1.53 > 10.3.5.8.46938: 51146 1/3/3 A 12.34.123.210 (157)
> 11) 20:08:05.590742: recv returned 108
> 12) 20:08:05.590810: setting verdict : accept the packet...
> 13) 20:08:05.590859 IP 10.3.5.8.46938 > 10.3.5.1.53: 48550+ AAAA? www.mydomain.net. (35)
> 14) 20:08:05.722533 IP 10.3.5.1.53 > 10.3.5.8.46938: 48550 0/1/0 (94)
> 
> I added line numbers. I also added a 100ms sleep after having accepted a packet
> to get a nice ordered output according to timings. Of course the very same
> problem is still happening without the sleep.
> 
> As you can see, the AAAA query is accepted by the queue but tcpdump doesn't see
> it passing, and the browser is waiting in vain for an answer. It retries both
> queries 5 seconds later, and this time, it works...
> 
> I could only reproduce this behavior within a web browser. Flooding the queue
> with DNS queries (while true ; do dig www.mydomain.net ; done), even
> simultaneously from two terminals (I have a 2 cores CPU) causes no trouble.
> 
> Using the queue on the DNS server side (2.6.37.2 too) in the INPUT chain
> produces the same behavior: the first AAAA browser DNS query is lost.
> 
> I tried libnetfilter_queue 0.0.17 and 1.0.0 without noticing any difference.
> When I tried the debian 2.6.32 kernel, it was working ok with the 1.0.0 lib, I
> did not try 0.0.17.
> 
> Any idea which could explain this behavior?
> 
> Thanks
> Fabien C.
> 
> PS: unrelated question, what should be a correct size of the recv() buffer: max
> ip packet size (~65536) + nfnl headers? MTU?

Check for errors in recv() to see if you are hitting ENOBUFS.
