From: Justin Michael Schwartzbeck <justinmschw@gmail.com>
Subject: How to do a NAT lookup from the kernel?
Date: Fri, 27 Mar 2015 10:13:59 -0500
Message-ID: <CAGEc96mSM_jAMPUVTHWQkdOTXrK3iTo8iboHW=6KO6ELEO3i6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:32924 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbbC0POB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 11:14:01 -0400
Received: by wgbgs4 with SMTP id gs4so11596700wgb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2015 08:13:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have been trying to figure out how to do a NAT lookup from the
kernel. I have been looking at connection tracking in the
documentation but I can't figure out exactly what this is capable of
or whether it can do what I want it to do.

This is my situation in detail: I have a client VM, a dNAT VM, and a
proxy VM. HTTP/HTTPS traffic from the client is routed to the dNAT VM
and is destination natted (via iptables rule) to the proxy VM and
proxy port. Right now I am having trouble with path MTU discovery and
am wanting to write a module that forwards ICMP (no route to host)
packets associated with an HTTP connection (sent back from the client)
back to the HTTP proxy and rewrites the translated IP/ports according
to what is in the NAT table for that connection. So basically when the
dNAT receives an ICMP (no route to host, fragmentation needed) from
the client side, I want to be able to look in the NAT table and do a
lookup on the source IP, destination IP, source port, and destination
port and find the associated connection to the proxy server. I know
this is possible because when I establish the connection I can do a
cat on /proc/net/nf_conntrack and get the full information, for
example, when the client makes a connection to slashdot this gets
printed:

ipv4     2 tcp      6 86396 ESTABLISHED src=(client vm ip)
dst=(slashdot ip) sport=1028 dport=80 src=(proxy vm ip) dst=(dnat vm
ip) sport=8080 dport=1028 [ASSURED] mark=0 secmark=0 use=2

The thing is I want to be able to get this information from within the
kernel. Any tips on how to do this?

Thanks so much.
