From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: cups slow on linux-2.6.24
Date: Sat, 2 Feb 2008 15:44:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802011530280.25878@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
 <47A07FEA.3000702@trash.net>  <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
  <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>
 <47A13573.7090804@trash.net>  <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
  <47A13FBD.8050803@trash.net>  <b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com>
  <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>
 <b6a2187b0801312128j19286ca1x9ba9af5a31ae7a96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	lkml <linux-kernel@vger.kernel.org>,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	"David S. Miller" <davem@davemloft.net>,
	cups-bugs <cups-bugs@easysw.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:41452 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbYBBOod (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:44:33 -0500
In-Reply-To: <b6a2187b0801312128j19286ca1x9ba9af5a31ae7a96@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jeff,

On Fri, 1 Feb 2008, Jeff Chua wrote:

> I recaptured it again, and attached are the logs.
[...]

Thank you! One can see a plain connection-initiating SYN, which triggers 
the message. No reply from the server, then three seconds later comes a 
retransmitted SYN and immediately after the SYN/ACK reply. What makes it 
interesting is that the first SYN was let through by the conntrack: it was 
*not* blocked at all.

In the dump file there is no other previous connection between 
127.0.0.1:1021 -> 127.0.0.1:515. But there must be a previous connection 
which was not captured by tcpdump.

Could I ask you to make two another tests? (I have been unable to 
reproduce the bug so far, but it must be my fault.) In both cases enable 
loggin invalid messages as Patrick wrote in a previous mail:

# modprobe ipt_LOG
# echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid

In the first case run the unpatched 2.4.24 kernel and before doing 
any printing, start dumping all the traffic at the 515 port so that we 
won't miss any connection and send the dump file:

# tcpdump -i lo -s 0 -w dump.pcap tcp port 515 

In the second case run the patched kernel and just start printing: do you 
get any 'nf_ct_tcp: invalid SYN' kernel message?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
