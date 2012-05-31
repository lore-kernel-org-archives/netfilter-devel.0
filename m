From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: filter IP protocol with ip6tables
Date: Thu, 31 May 2012 12:17:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205311216370.30809@frira.zrqbmnf.qr>
References: <856i5i0.8d94641ae92b968dc968d4a2d41e077f@obelix.schillstrom.com> <4FC73784.4030206@umic.rwth-aachen.de> <4FC74271.3030006@umic.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bernd Kohler <kohler@umic.rwth-aachen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35252 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab2EaKRD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 May 2012 06:17:03 -0400
In-Reply-To: <4FC74271.3030006@umic.rwth-aachen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-05-31 12:05, Bernd Kohler wrote:

>just one more question.
>
>On 05/31/2012 11:19 AM, Bernd Kohler wrote:
>>>...
>>> Next header   0 is Hop-by-hop option header 
>>> Next header 41 is IPv6 in IPv6
>> ...
>
>as Hans Schillstrom and Jan Engelhardt referred right to "0" being
>proto-# for Hop-by-Hop not classic IP(v4) , shouldn't netfilter indicate
>"0" as hop-by-hop and not "all"?

iptables only uses what your system ships. If it ships nonsensical 
and/or outdated files, you should complain to Debian.
