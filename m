From: d i <navilein@hotmail.com>
Subject: loopback forwarding not working (aka implicit source local NAT)
Date: Wed, 17 Sep 2008 16:35:47 +0000
Message-ID: <BLU144-W44C48F9DBE68BEE223EE6FD14C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu0-omc1-s12.blu0.hotmail.com ([65.55.116.23]:9137 "EHLO
	blu0-omc1-s12.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbYIQQl5 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:41:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,
I understood that iptables (my version is 1.4.0) do not longer support implicit source local NAT, i.e., the effect of 
iptables -t nat -A OUTPUT -p tcp --dport 222 -t DNAT --to-destination ${LANIP}:22
which allows one to  write on the local machine:
ssh -p 222 localhost
and connect to the LAN machine with address ${LANIP} on the ssh port.
 
Can you please confirm this is no longer available ? I get no error when I use it, but it doesn't work either... (while logging, the packets in the OUTPUT chain have destination  127.0.0.1, although it should be ${LANIP}; also the port is the same 222)

Is there a way to activate/enable it ?
If not, is there a way around it? I (would prefer not to have high level applications that do this, but rather do it in the kernel)

>From a developer point of view it might seem useless to have something like this, since at any time one could just directly connect to that destination:port, without a loopback forwarding. However, I think this is at least useful for my particular situation:
 
I am a subnet inside another subnet and I have no access to the public router, other than getting DNS and having my connections routed. 
So my WAN IP is not public. In order to access my router from the outside world, I am using a reverse ssh tunnel to a computer which is public and to which I have access. This reverse ssh tunnel is nothing but remote port  forwarding of the ssh.
 
Using this reverse ssh tunnel, I can connect (ssh) to my router directly from outside by connecting to a local port on that public computer.
 
I would like to have the same for the other machines in my subnet:  
I want to forward some ports on my router towards the ssh ports of my LAN machines, and using the ssh reverse tunnel port forwarding I can connect to them from the outside world. This is where I would need the implicit source local NAT: these ports would be forwarded (by iptables) towards my subnet machines (ssh port).
 
 
Thanks for any help!
 
PS: please CC any response to my email address. 
PS2: sorry if this is not the typical message bound for the netfilter-devel, but I've asked this on the users mail list as well, and I got no answer...
_________________________________________________________________
Discover the new Windows Vista
http://search.msn.com/results.aspx?q=windows+vista&mkt=en-US&form=QBRE