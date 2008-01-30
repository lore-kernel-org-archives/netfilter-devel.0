From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel crash in nf_nat_move_storage
Date: Wed, 30 Jan 2008 14:30:11 +0100
Message-ID: <47A07BE3.7000600@trash.net>
References: <47A062BF.1010008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51152 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYA3Na3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:30:29 -0500
In-Reply-To: <47A062BF.1010008@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Woerner wrote:
> Hello,
> 
> Using port forwarding from port 80 to 21 with nf_conntrack_ftp loaded 
> results in a kernel crash, when connecting to port 80 from a remote
> host. This seems to be a problem for kernels > 2.6.18 including 2.6.24.
> 
> Steps to Reproduce:
> 
> host1> iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT 
> --to :21
> host1> iptables -t filter -A INPUT -i eth0 -m state --state NEW -m tcp 
> -p tcp --dport 21 -j ACCEPT
> host1> modprobe ip_conntrack_ftp
> host2> telnet host1 80
> 
> Attached is the kernel crash log for kernel 2.6.23.9-85.fc8PAE. I was 
> told that this kernel crash dump is incomplete, but it took several 
> attempts to get a log with more that 5 lines over serial console. The 
> kernel seems to die too fast.


This is already fixed in 2.6.23.10.
