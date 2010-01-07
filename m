From: Vikram Ragukumar <vragukumar@signalogic.com>
Subject: Query regarding libnetfilter_queue usage
Date: Wed, 06 Jan 2010 19:54:17 -0600
Message-ID: <4B453EC9.90300@signalogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-64-219-188-225.dsl.rcsntx.swbell.net ([64.219.188.225]:33441
	"EHLO nuntius.signalogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932650Ab0AGCLh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:11:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Pardon me for posting on both netfilter and netfilter_devel, because i 
am unsure of which list would be more appropriate for my question.

I am writing an application using libnetfilter_queue that should perform 
the following function

- Receives packets from NFQUEUE
- Apply a decryption algorithm to packets
- Issue an ACCEPT verdict for decrypted packets

These packets are destined to another box behind the firewall running 
the above mentioned application.

Based on Fig 14-1 from the link below
http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch14_:_Linux_Firewalls_Using_iptablesI 

I intend on siphoning out network packets at the PREROUTING chain of the 
Mangle table by using

iptables -t mangle -A PREROUTING -i eth0 -p 1234 -j NFQUEUE

1) I would like to know if the PREROUTING chain in the mangle table is 
an appropriate place to pick off the encrypted packets ?
2) Once the ACCEPT verdict is issued will the modified packets resume 
processing along the PREROUTING chain of the mangle table ?
3) Is there a well documented reference for API's that i will need to 
use while developing this application ?

Thanks in advance,
Regards,
Vikram.

