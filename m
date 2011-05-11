From: Ed W <lists@wildgooses.com>
Subject: Should conntrack track *everything* into some "connection"?
Date: Wed, 11 May 2011 10:24:29 +0100
Message-ID: <4DCA55CD.5000409@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:41832 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab1EKQfo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 12:35:44 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 89517340377
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2011 10:24:30 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id uaHIPDvvxrqI for <netfilter-devel@vger.kernel.org>;
	Wed, 11 May 2011 10:24:30 +0100 (BST)
Received: from Ed-Wildgooses-MacBook-Pro.local (office.nippynetworks.com [212.69.49.94])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id 3D717340376
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2011 10:24:30 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Apologies that this is a repost of a question on the users list.  I just 
wanted to rephrase the question in terms of "what *should* happen" so 
that I can understand the limitations of conntrack

Q: Should conntrack track *every* IP packet in/out of a machine?
Q: Are there any known limitations to accounting at the moment? 
eg corrupted packets, icmp unsolicited responses, tcp resends, etc?


If the answer is that conntrack *should* track all packets then I 
have found an example that it is not tracking the ICMP Unreachable 
response which occurs when a remote UDP packet is returned to a 
local socket which has since been closed.


To clarify the situation, I have been experimenting with logging conntrack 
flows using ulogd2.  However, the numbers aren't stacking up against a 
simple iptables accounting rule...  

An example seems to be to cause a name lookup via dnsmasq. For whatever 
reason this does two simultaneous dns requests to both configured dns 
servers.  One reply comes back slightly quicker than the other and the 
slower reply appears to cause a local ICMP unreachable response to be 
generated (I think dnsmasq closes it's listening socket once it gets an 
answer).  Everything is logged *except* the data for the ICMP unreachable 
response?

So tcpdump gives me (note sizes are payload, add 28 to compare with conntrack):

22:23:40.151666 IP 10.141.36.76.25630 > 8.8.4.4.53: 11049+ AAAA? www.yahoo.co.uk. (33)
22:23:40.151993 IP 10.141.36.76.25630 > 8.8.8.8.53: 11049+ AAAA? www.yahoo.co.uk. (33)
22:23:40.850776 IP 8.8.4.4.53 > 10.141.36.76.25630: 11049 3/1/0 CNAME rc.yahoo.com., CNAME rc.g01.yahoodns.net., CNAME any-rc.a01.yahoodns.net. (178)
22:23:41.014108 IP 8.8.8.8.53 > 10.141.36.76.25630: 11049 3/1/0 CNAME rc.yahoo.com., CNAME rc.g01.yahoodns.net., CNAME any-rc.a01.yahoodns.net. (178)

22:23:41.014217 IP 10.141.36.76 > 8.8.8.8: ICMP 10.141.36.76 udp port 25630 unreachable, length 214

22:23:41.401743 IP 10.141.36.76.10248 > 8.8.4.4.53: 25285+ A? www.yahoo.co.uk. (33)
22:23:41.764124 IP 8.8.4.4.53 > 10.141.36.76.10248: 25285 4/0/0 CNAME rc.yahoo.com., CNAME rc.g01.yahoodns.net., CNAME any-rc.a01.yahoodns.net., A 77.238.178.122 (133)


However, conntrack gives me:

May  9 22:24:10 localhost [DESTROY] ORIG: SRC=10.141.36.76 DST=8.8.4.4 PROTO=UDP SPT=25630 DPT=53 PKTS=1 BYTES=61 , REPLY: SRC=8.8.4.4 DST=10.141.36.76 PROTO=UDP SPT=53 DPT=25630 PKTS=1 BYTES=206 
May  9 22:24:10 localhost [DESTROY] ORIG: SRC=10.141.36.76 DST=8.8.8.8 PROTO=UDP SPT=25630 DPT=53 PKTS=1 BYTES=61 , REPLY: SRC=8.8.8.8 DST=10.141.36.76 PROTO=UDP SPT=53 DPT=25630 PKTS=1 BYTES=206 
May  9 22:24:11 localhost [DESTROY] ORIG: SRC=10.141.36.76 DST=8.8.4.4 PROTO=UDP SPT=10248 DPT=53 PKTS=1 BYTES=61 , REPLY: SRC=8.8.4.4 DST=10.141.36.76 PROTO=UDP SPT=53 DPT=10248 PKTS=1 BYTES=161 


Basically it's missing any count for the packet with tcpdump 
timestamp: 22:23:41.014217 - ie the port unreachable response?  
This is confirmed by looking at the iptables counts


Is this a "bug" in conntrack or in ulogd?

Anyone know of any other reasons that conntrack accounting might not count some traffic? (corrupted packets? tcp resends?)

Thanks

Ed W
