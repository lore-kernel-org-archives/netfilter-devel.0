From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.10
Date: Tue, 02 Nov 2010 16:40:14 +0000
Message-ID: <4CD03EEE.5050900@googlemail.com>
References: <4CCAEB8A.5090504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48221 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab0KBQkW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:40:22 -0400
In-Reply-To: <4CCAEB8A.5090504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> The netfilter coreteam presents:
>
>     iptables version 1.4.10
>   
General question: Would it be safe to compile this (from source) and 
install it on my system which has the 2.6.16.60 kernel and iptables 
1.3.7 installed and running?

I am quite desperate to get ipset working on that machine and, as I 
understand it, I have a choice of either compiling the 1.3.7 version 
(adding kernel/include/linux/netfilter_ipv4/ip_set.h from ipset source 
tree to include/linux/netfilter_ipv4 prior to that) or compile the 
latest 1.4.10 version of iptables prior to compiling and installing ipset.

I just compiled both versions of iptables and did 'make' successfully, 
though I haven't yet made the install.

