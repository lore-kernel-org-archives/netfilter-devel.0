From: Bozeanu Andrei <andrei.bozeanu@cert-ro.eu>
Subject: a problem with netfilter
Date: Wed, 17 Oct 2012 15:34:11 +0300
Message-ID: <507EA5C3.6020903@cert-ro.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0a.cert-ro.eu ([192.166.122.27]:29993 "EHLO mx0a.cert-ro.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab2JQMoR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:44:17 -0400
Received: from mx1.cert-ro.eu (localhost [127.0.0.1])
	by mx1.cert-ro.eu (Postfix) with ESMTP id 7D1D8125061
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Oct 2012 15:34:08 +0300 (EEST)
Received: from [192.168.201.19] (unknown [192.166.122.3])
	by mx1.cert-ro.eu (Postfix) with ESMTPSA id 5E4A1124F99
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Oct 2012 15:34:08 +0300 (EEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey all,

I am writing a linux firewall kernel module (something a bit specific)
using Netfilter, in C. I extract the
TCP header and the IP header using the functions tcp_hdr() and ip_hdr()
on the skb. I extract the source and
destination IPs without any problem, yet, when I try to see the source
port and the destination port i get wrong
values.

sport = ntohs(tcp_hdr(skb)->source);
dport= ntohs(tcp_hdr(skb)->dest);

I use printk to send the info to the syslog and
printk(KERN_INFO "got data on port %hu from source port %hu\n", dport,
sport);

the result i get is
"got data on port 17680 from port 84"
"got data on port 17680 from port 84"
"got data on port 17680 from port 100"

while netstat shows me that the right values for these ports are dport =
56188 and sport = 22.

I must be doing something wrong or missing something of the bigger
picture, I would apreciate any insight
on why this behavior is generated.

Thank you all,
A.

