From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: a problem with netfilter
Date: Thu, 18 Oct 2012 04:15:56 +0200
Message-ID: <507F665C.40507@mutluit.com>
References: <507EA5C3.6020903@cert-ro.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab2JRCQQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:16:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1TOfel-0006CH-MB
	for netfilter-devel@vger.kernel.org; Thu, 18 Oct 2012 04:16:19 +0200
Received: from 77-21-150-226-dynip.superkabel.de ([77.21.150.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Oct 2012 04:16:19 +0200
Received: from for-gmane by 77-21-150-226-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Oct 2012 04:16:19 +0200
In-Reply-To: <507EA5C3.6020903@cert-ro.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bozeanu Andrei wrote, On 10/17/2012 02:34 PM:
> Hey all,
>
> I am writing a linux firewall kernel module (something a bit specific)
> using Netfilter, in C. I extract the
> TCP header and the IP header using the functions tcp_hdr() and ip_hdr()
> on the skb. I extract the source and
> destination IPs without any problem, yet, when I try to see the source
> port and the destination port i get wrong
> values.
>
> sport = ntohs(tcp_hdr(skb)->source);
> dport= ntohs(tcp_hdr(skb)->dest);

Just guessing: maybe ntohs has already been applied to source and dest, so try it w/o ntohs()...

> I use printk to send the info to the syslog and
> printk(KERN_INFO "got data on port %hu from source port %hu\n", dport,
> sport);
>
> the result i get is
> "got data on port 17680 from port 84"
> "got data on port 17680 from port 84"
> "got data on port 17680 from port 100"
>
> while netstat shows me that the right values for these ports are dport =
> 56188 and sport = 22.
>
> I must be doing something wrong or missing something of the bigger
> picture, I would apreciate any insight
> on why this behavior is generated.
>
> Thank you all,
> A.


