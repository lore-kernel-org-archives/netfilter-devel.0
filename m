From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Tue, 23 Oct 2007 15:17:11 +0200
Message-ID: <471DF457.3010404@trash.net>
References: <001f01c8142e$e6a67960$ea50f53c@FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ron Lai <ronlai@cs.stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45426 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXJWNSJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:18:09 -0400
In-Reply-To: <001f01c8142e$e6a67960$ea50f53c@FireEye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Please send bugreports to netfilter-devel.

Ron Lai wrote:
> Hi all,
> My 2.6.22.6 Linux box is acting as a NAT device. I found that a NATted 
> FTP client is having problem using active mode to connect to a outside 
> FTP server. (Passive mode works fine.)
> 
>> From the trace I could see that the PORT command from the FTP client is 
> correctly modified by the Linux box to use the converted NAT address. 
> However, the confirmation from the server never makes it to the client 
> and the client just keeps retransmitting the PORT command packet.


Do you mean it never makes it to the FTP client or to the machine
where the client is running?

> The interesting part is that active mode can work if the length of the 
> actual IP address of the client is the same as the length of the 
> converted NAT address. It looks like if there is no TCP sequence number 
> modification by the Linux box, the FTP connection can work properly in 
> active mode. I am suspecting that there may a problem in the TCP 
> sequence number tracking in the kernel modules.
> 
> The same settings work fine when I try with Linux 2.6.15 loading 
> ip_nat_ftp.ko and ip_conntrack_ftp.ko. Did I miss anything in 
> configuring the Linux 2.6.22.6 box?


Works fine here. Please post the dump, ideally from a box in the
middle.
