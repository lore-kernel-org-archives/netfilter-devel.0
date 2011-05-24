From: Pierre Rondou <prondou@gmail.com>
Subject: EXPORT_SYMBOL missing in the kernel?
Date: Tue, 24 May 2011 15:03:34 +0200
Message-ID: <4DDBACA6.2060501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: evyncke@cisco.com, guy.leduc@ulg.ac.be,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:44782 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756112Ab1EXNDe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 09:03:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm a student at the University of Liege, currently developing a NAT64 
(see RFC 6146) module for Netfilter.

In order to develop this module, I had to use some in-kernel function, 
such as icmp_send, ip6_output, ip_finish_output, ... and many more.

But many of those functions didn't have an "EXPORT_SYMBOL" allowing them 
to be reachable from outside the kernel.

So, to be able to use them, I had to copy paste about 1500 lines of 
kernel source code (those functions + related functions). This makes the 
module hardly updatable as all those functions are likely to be updated.

Is there a reason why those functions are not associated with an 
"EXPORT_SYMBOL"?

Regards,

Pierre Rondou
