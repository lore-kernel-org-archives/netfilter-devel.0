From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: option to disable /proc/net/nf_conntrack procfs [was Re: netfilter
 patches for 3.0.0-rc1]
Date: Mon, 06 Jun 2011 01:07:05 +0200
Message-ID: <4DEC0C19.1000205@netfilter.org>
References: <4DE79466.6080400@netfilter.org> <alpine.LNX.2.01.1106031052210.32042@frira.zrqbmnf.qr> <4DE8AE7D.8060609@netfilter.org> <alpine.LNX.2.01.1106031605160.15918@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60000 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab1FEXHJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 19:07:09 -0400
In-Reply-To: <alpine.LNX.2.01.1106031605160.15918@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/06/11 16:06, Jan Engelhardt wrote:
> On Friday 2011-06-03 11:50, Pablo Neira Ayuso wrote:
> 
>> On 03/06/11 10:53, Jan Engelhardt wrote:
>>> netfilter: provide config option to disable ancient procfs parts
>>>
>>> +config NF_CONNTRACK_PROCFS
>>> +	bool "Supply CT list in procfs (OBSOLETE)"
>>> +	default y
>>> +	depends on PROC_FS
>>> +	---help---
>>> +	This option enables for the list of known conntrack entries
>>> +	to be shown in procfs under net/netfilter/nf_conntrack. This
>>> +	is considered obsolete in favor of using the conntrack(8)
>>> +	tool which uses Netlink.
>>> +
>>
>> This still misses /proc/net/ip_conntrack which would be available. See
>> nf_conntrack_l3proto_ipv4_compat.c
> 
> Hm indeed. New try:
> 
> parent 6b914d11bc76286fd6d39833d046a3ce32a9b3cb (v3.0-rc1-100-g6b914d1)
> commit 80a72a00f509c26f9fa50434e0a3df6274f01484
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Apr 21 09:32:45 2011 +0200
> 
> netfilter: provide config option to disable ancient procfs parts
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks.
