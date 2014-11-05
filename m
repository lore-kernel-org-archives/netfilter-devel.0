From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: recent module
Date: Wed, 5 Nov 2014 02:24:33 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1411050221020.30231@aurora.sdinet.de>
References: <8D1C569F1803AFD-7C0-3D4A0@webmail-vm135.sysops.aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pietro Paolini <pulsarpietro@aol.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blackhole.sdinet.de ([176.9.52.58]:49548 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKEBYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:24:50 -0500
In-Reply-To: <8D1C569F1803AFD-7C0-3D4A0@webmail-vm135.sysops.aol.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 3 Nov 2014, Pietro Paolini wrote:

> -A INPUT -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW -m
> recent --update --seconds 1800 --hitcount 5 --name ssh-defensive
> --rsource -j DROP

> Chain INPUT (policy ACCEPT 81 packets, 8996 bytes)
>  pkts bytes target     prot opt in     out     source
> destination
>     1    52 LOG        tcp  --  *      *       0.0.0.0/0
> 0.0.0.0/0            state NEW tcp dpt:22 LOG flags 0 level 4

> I expected to see more packets, what about the TCP handshake ?

-m state --state NEW means "the first packet in the connection", aka 
mostly the TCP SYN - not the rest, like SYN-ACK and following.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
