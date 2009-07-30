From: "Srinivasan, Suman (Suman)** CTR **"
	<suman.srinivasan@alcatel-lucent.com>
Subject: Modifying packets in userspace using libnetfilter_queue
Date: Thu, 30 Jul 2009 09:18:41 -0500
Message-ID: <5BB67BF4A0D4544A918C2FD76487A1E13D8944D6@USNAVSXCHMBSB2.ndc.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ihemail4.lucent.com ([135.245.0.39]:49783 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZG3OSr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:18:47 -0400
Received: from ihrh1.emsr.lucent.com (h135-1-218-53.lucent.com [135.1.218.53])
	by ihemail4.lucent.com (8.13.8/IER-o) with ESMTP id n6UEIjkG023922
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2009 09:18:45 -0500 (CDT)
Received: from USNAVSXCHHUB03.ndc.alcatel-lucent.com (usnavsxchhub03.ndc.alcatel-lucent.com [135.3.39.112])
	by ihrh1.emsr.lucent.com (8.13.8/emsr) with ESMTP id n6UEIis5013548
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2009 09:18:45 -0500 (CDT)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

Sorry for this elementary question, but I am new to the world of packet modification. I browsed the recent netfilter-devel archives and couldn't find much on this topic.

I am trying to modify TCP packets in userspace. I know it is inefficient to do it in userspace, but I just need a prototype to test for now.

I couldn't find much documentation on doing this, except for the documentation on the following URL, the nfqnl_test.c file and some modifications on some mailing lists:
http://www.nufw.org/doc/libnetfilter_queue/

I have gotten this far:
1. Have set up iptables rules to send the TCP packets I want to intercept down a NFQUEUE queue. 
2. Am able to use nfqnl_test.c to receive and print out packet info. 
3. Used netinet/tcp.h and sample code to check TCP headers 
4. Able to print out TCP payload using TCP and IP header information 
5. Able to modify the TCP payload (or at least the copy) 
 
However, the modified packets are not really being transmitted! I assume this is because I am getting a copy of the packets or the packet data. Other than getting/setting the TCP and payload data, the rest of the code to intercept the packet is still the basic nfqnl_test.c code.

How do I actually modify the packet in userspace so that it is sent out over the network?

Also, if I modify the TCP packets and add more data to the payload, what would I change? I assume that I would only have to change the following:

- TCP payload length
- Checksum
- IP length (?, would I have to touch this field)

Is there anything else that I am not thinking of?

By the way, the documentation available out there is a little hard for a newcomer to the world of iptables/netfilter. I'm getting a little lost with all the talk about libipq, libiptc, etc. Is there any documentation on the history of iptables/netfilter and which libraries have been retired or are still active?

Sorry for this long e-mail.

Thank you,
Suman

--
Falun Gong: www.falundafa.org | www.faluninfo.net
Peaceful meditation faces persecution in mainland China
