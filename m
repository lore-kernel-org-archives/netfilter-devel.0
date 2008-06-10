From: Petr Pisar <petr.pisar@atlas.cz>
Subject: Re: iptables-1.4.1: ip6tables -L prints network mask instead of prefix length
Date: Tue, 10 Jun 2008 13:01:33 +0000 (UTC)
Message-ID: <slrng4supd.77p.petr.pisar@album.ics.muni.cz>
References: <slrng4sqhq.6hn.petr.pisar@album.ics.muni.cz> <alpine.LNX.1.10.0806101405300.20733@fbirervta.pbzchgretzou.qr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:60567 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYFJNBm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:01:42 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K63To-0005Lp-LT
	for netfilter-devel@vger.kernel.org; Tue, 10 Jun 2008 13:01:40 +0000
Received: from album.ics.muni.cz ([147.251.23.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2008 13:01:40 +0000
Received: from petr.pisar by album.ics.muni.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2008 13:01:40 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008-06-10, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Tuesday 2008-06-10 13:49, Petr Pisar wrote:
>>Hello,
>>
>>I found regression between iptables 1.4.0 and 1.4.1-rc1 (also in
>>1.4.1). The "ip6tables -nL" prints source and destination addresses in
>>NETWORK/NETMASK instead of NETWORK/PREFIXLEN as used in iptables 1.4.0.
>>
>>This doesn't happen if the PREFIXLEN is 0 (i.e. ::/0).
>
> (It does not happen if PREFIXLEN is a multiple of 32.)
> Fix below.
>
> commit f52d74a1a83c4fa30fcab8b318d325bb3c9b5535
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Jun 10 14:05:21 2008 +0200
>
This patch makes ip6tables much better. Works for me. Thanks.

-- Petr


