From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Mon, 29 Oct 2007 13:51:47 +0100
Message-ID: <4725D763.9080104@trash.net>
References: <001f01c8142e$e6a67960$ea50f53c@FireEye.com> <471DF457.3010404@trash.net> <002401c81638$d97f2ff0$050ba8c0@FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ron Lai <ronlai@cs.stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59814 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbXJ2MyH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:54:07 -0400
In-Reply-To: <002401c81638$d97f2ff0$050ba8c0@FireEye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Ron Lai wrote:
> The packet dump from the 2.6.22.6 box in the middle is attached. In the 
> trace 172.16.119.91 is the original IP address of the FTP client and 
> 172.16.255.123 is the NATted address. The FTP server's address is 
> 172.16.118.1.
> 
> The problem happens between packet 31 and packet 34. Packet 31 indicates 
> that the client expects ACK number 0x64b4dda9 for the PORT command it 
> sends. However, the ACK number it actually gets is 0x64b4dda8.


Thats really odd. It properly adjusts the sequence number in the
original direction by +1, but incorrectly adjusts the acknowledgement
in the reply direction by -2. I don't see how this could happen with
the vanilla 2.6.22 kernel, are you using any additional patches?

Otherwise please edit net/ipv4/netfilter/nf_nat_helper.c and add
a #define DEBUG at the first line, recompile and post the output
of the failed session (ideally two failed sessions). Thanks.

