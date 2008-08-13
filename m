From: "Andy Loukes" <andy@loukes.com>
Subject: Netfilter development project
Date: Wed, 13 Aug 2008 18:20:15 +0100
Message-ID: <000501c8fd68$da840390$8f8c0ab0$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from milford.g2t.co.uk ([84.234.16.49]:46890 "EHLO milford.g2t.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYHMRdk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:33:40 -0400
Received: from [82.132.136.205] (port=34471 helo=TC000142)
	by milford.g2t.co.uk with asmtp (Exim 4.41)
	id 1KTK1h-0001Lj-Bf
	for netfilter-devel@vger.kernel.org; Wed, 13 Aug 2008 18:20:50 +0100
Content-Language: en-gb
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

My company needs to develop two netfilter applications.

First a simple daemon which listens on a tcp socket for messages which
inform it to add or remove specific iptables rules. It needs to be
secure, very high performance and deal with multiple concurrent 
requests. We currently use iptables rules, but when I get time I'm going
to try out using IPSet as it seems more appropriate.

Second an accounting daemon, it needs to connect to another server using
a to-be-defined protocol to update the packet and byte counts, in and
out per source ip address.

I have proposed to my company that I send this out to the netfilter-dev 
list because we don't have the resource available at the moment and our 
dev team aren't particularly familiar with netfilter.

We are obviously prepared to pay!

The company is based in London although geography doesn't need to be 
particularly relevant.

Please contact me with a brief CV, any examples of code and why you 
think you should do it!

Clearly if these applications could be made useful to the wider 
community then it would be better for everyone.

I hope this is an appropriate list for this request, I did check the rules!

Regards

Andy








