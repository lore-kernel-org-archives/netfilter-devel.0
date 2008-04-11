From: Thomas Mader <thezema@gmail.com>
Subject: Re: Throughput test for kernelspace module vs. userspace daemon with
 strange results
Date: Fri, 11 Apr 2008 17:01:01 +0200
Message-ID: <47FF7D2D.20804@gmail.com>
References: <47FF613C.4010701@gmail.com> <alpine.LNX.1.10.0804111509140.21182@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:59817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725AbYDKPBF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:01:05 -0400
Received: by fg-out-1718.google.com with SMTP id l27so424375fgb.17
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2008 08:01:04 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0804111509140.21182@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> You are using a raw socket in userspace, which effectively
> bypasses Netfilter.
> To make a meaningful test of it, the PF_RAW code would need
> an NF_HOOK into iptables to make a more accurate comparison I think.

I don't understand what you mean since I also have a raw socket in 
kernelspace. Is it because I use kernel_sendmsg to send the icmp packet 
in kernelspace? I cannot believe that I get a ~5mbit/s decrease in 
throughput only because the sent icmp packets go through my module in 
kernelspace but not in userspace.

Nevertheless I removed the icmp send stuff from both and tested again. 
Now I get 95.60mbit/s for kernelspace and 95.69mbit/s for userspace. I 
think I can conclude that there is no drawback in throughput performance 
by using the userspace daemon, though the reason for it is still unknown.
