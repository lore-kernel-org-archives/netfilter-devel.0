From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Nat+Iptables+Tcp Keepalive Problem
Date: Thu, 4 Jun 2009 16:59:06 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906041656220.16139@blackhole.kfki.hu>
References: <4A27C999.3000609@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Emiliano Romero <emilianoromero@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:60678 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbZFDO7F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:59:05 -0400
In-Reply-To: <4A27C999.3000609@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 4 Jun 2009, Emiliano Romero wrote:

> I'm doing a DNAT to forward connections to port 5555 to another server. The
> connection gets forwarded fine, I can connect, send and recieve data over that
> connection. The problem appear with TCP KeepAlive packets (No flags, win=0,
> len=0). When that packets of a connection that is ESTABLISHED (Send and
> recieve data before) arrives to my iptables machine. They arent matched with
> nat entries of the conection where it belongs. So they are marked as INVALID
> and go to INPUT insted of FORWARD.
> 
> TCP Keepalive in the remote side (The one that start the connection) is seted
> at 20 seconds with 4 tries at 10 seconds each one. That's because it's over a
> very bad communication channel.
> 
> I add some of my configurations:
> 
> Iptables config:
> iptables -t raw -A PREROUTING -p tcp --dport 5555 -j TRACE
> iptables -t nat -A PREROUTING -p tcp --dport 5555 -j DNAT --to-destination
> 192.168.1.100:5555
> 
> Output of Trace: http://pastebin.com/f65e41319
> 
> Visual Output of Wireshark of another try: http://tinyurl.com/qlaj9n

The TCP keepalived packet in the output above is invalid: it's sequence 
number is wrong.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
