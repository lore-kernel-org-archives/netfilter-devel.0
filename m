From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] xtables: use guarded types
Date: Thu, 9 Dec 2010 20:25:46 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr> <4D00B2D7.4010401@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45097 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab0LITZr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:25:47 -0500
In-Reply-To: <4D00B2D7.4010401@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-12-09 11:43, Pablo Neira Ayuso wrote:

>On 03/12/10 20:13, Jan Engelhardt wrote:
>> parent b880c1f077000956b9f475d5f3b6c5e45ff2e342 (v2.6.37-rc1-241-gb880c1f)
>> commit 4826151aedbe6e364b7b801f026fbe7383904b6a
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Thu Dec 2 21:01:17 2010 +0100
>> 
>> netfilter: xtables: use guarded types
>> 
>> We are supposed to use the kernel's own types in userspace exports.
>
>What's the point to have different headers in the kernel source code
>tree and iptables?

Because iptables needs to know more structs than the kernel provides.

But... what does that have to do with the patch?
