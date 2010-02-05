From: "Nishit Shah" <nishit@elitecore.com>
Subject: RE: kernel panic with ip_conntrack with kernel 2.6.16.13
Date: Fri, 5 Feb 2010 18:18:24 +0530
Message-ID: <005901caa661$81650400$842f0c00$@com>
References: <001301caa5ca$2b50e8a0$81f2b9e0$@com> <alpine.LSU.2.01.1002051323130.7363@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Netfilter Developer Mailing List'"
	<netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:36923 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755525Ab0BEMn6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:43:58 -0500
In-Reply-To: <alpine.LSU.2.01.1002051323130.7363@obet.zrqbmnf.qr>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks Jan,
	
	Besides kernel upgrade, is there a way ? as hardware is running in
production 2.6.16 environment. :(
	Any information regarding understanding the kernel panic or fix is
really appreciated. 

Rgds,
Nishit Shah


-----Original Message-----
From: Jan Engelhardt [mailto:jengelh@medozas.de] 
Sent: Friday, February 05, 2010 5:55 PM
To: Nishit Shah
Cc: Netfilter Developer Mailing List
Subject: Re: kernel panic with ip_conntrack with kernel 2.6.16.13

On Thursday 2010-02-04 19:45, Nishit Shah wrote:

>Hi,
>
>	Please find the panic below. I am not able to reproduce it but I am
>getting it very frequently.
>	Kernel version is ? 2.6.16.13
>	Any suggestions/directions ??

Try a newer kernel, it could be fixed long already.

