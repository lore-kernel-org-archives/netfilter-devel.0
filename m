From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.10
Date: Wed, 03 Nov 2010 10:51:16 +0100
Message-ID: <4CD13094.4060505@trash.net>
References: <4CCAEB8A.5090504@trash.net> <4CD03EEE.5050900@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46848 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0KCJvU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:51:20 -0400
In-Reply-To: <4CD03EEE.5050900@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.11.2010 17:40, Mr Dash Four wrote:
> 
>> The netfilter coreteam presents:
>>
>>     iptables version 1.4.10
>>   
> General question: Would it be safe to compile this (from source) and
> install it on my system which has the 2.6.16.60 kernel and iptables
> 1.3.7 installed and running?

Yes, that should work. Generally newer kernels may require newer
versions of iptables because old match or target revisions got
removed in the kernel, but the other way around should always work.

> I am quite desperate to get ipset working on that machine and, as I
> understand it, I have a choice of either compiling the 1.3.7 version
> (adding kernel/include/linux/netfilter_ipv4/ip_set.h from ipset source
> tree to include/linux/netfilter_ipv4 prior to that) or compile the
> latest 1.4.10 version of iptables prior to compiling and installing ipset.
> 
> I just compiled both versions of iptables and did 'make' successfully,
> though I haven't yet made the install.
