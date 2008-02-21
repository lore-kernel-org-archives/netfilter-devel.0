From: Patrick McHardy <kaber@trash.net>
Subject: RFC: SAME removal and NAT IP selection
Date: Thu, 21 Feb 2008 13:41:43 +0100
Message-ID: <47BD7187.7000403@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:51981 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756558AbYBUMmE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:42:04 -0500
Received: from [192.168.0.100] (really [78.42.105.25])
          by viefep19-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080221124200.ZKSA2163.viefep19-int.chello.at@[192.168.0.100]>
          for <netfilter-devel@vger.kernel.org>;
          Thu, 21 Feb 2008 13:42:00 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As soon as we've removed the SAME target, I got some complaints
from users that not only need persistent IPs when talking to the
same destination, but for all destinations, which NAT currently
doesn't provide.

I don't want to resurrect the SAME target because of the 32/64bit
compat problems it had, it would be better to handle this in the
NAT core. The IP is currently determined by hashing the source and
destinations IPs and mapping the hash to the NAT range:

         minip = ntohl(range->min_ip);
         maxip = ntohl(range->max_ip);
         j = jhash_2words((__force u32)tuple->src.u3.ip, 

                          (__force u32)tuple->dst.u3.ip, 0);
         j = ((u64)j * (maxip - minip + 1)) >> 32;
         *var_ipp = htonl(minip + j);

We have two options:

- add a flag to the NAT range to ignore the destination
   IP for SNAT

- always ignore the destination IP for SNAT

I personally prefer the second option since it results in more
consistency and avoids adding new a option. I'm can't think
of a reason why we would need to include the destination for
SNAT, using jhash should result in good distribution anyway,
but I might be missing something.

Any opinions?
