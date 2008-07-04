From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: TCP connection stalls under 2.6.24.7
Date: Fri, 4 Jul 2008 16:54:14 +0200
Message-ID: <200807041654.15591.thomas.jarosch@intra2net.com>
References: <47EA0DAB.7080205@securenet.de> <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu> <47F08A52.9070802@securenet.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Sven Riedel <sr@securenet.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:59873 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYGDOyT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:54:19 -0400
In-Reply-To: <47F08A52.9070802@securenet.de>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello together,

we upgraded from kernel 2.6.23.16 to 2.6.24.7 and are now seeing
stalling (smtp) TCP connections on two boxes. We still have the old kernel
on a "rescue" partition. If I boot it up, the connections work immediately.

The connection work fine if the transmitted data is smaller than ~220kb,
so you still can send small messages. I've sent a tcpdump to Patrick in 
private as it contained sensitive information. The picture is similar to 
Sven's issue reported backed in march: Some ACK packets
are missing (as if the remote side never sent them).

I downgraded the box to 2.6.24 to make sure it was
not caused by any -stable patch. Same thing.

Did any default TCP settings change from 2.6.23.16 to 2.6.24?

I also tried to disable path MTU discovery, TCP window scaling and
lowered the MTU of the ppp0 interface to 1400 (DSL connection).
This had no visible effect.

@Sven: Were you able to test 2.6.24.2?

Patrick suggested to enable nf_conntrack_log_invalid.
I enabled it via "echo 255 > /proc/sys/net/netfilter/nf_conntrack_log_invalid"
but that change didn't print anything to syslog.

Any ideas?

Have a nice weekend,
Thomas
