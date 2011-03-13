From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: conntrack -L shows nothing
Date: Sun, 13 Mar 2011 13:54:45 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103131354340.30398@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1103112029440.10848@obet.zrqbmnf.qr> <4D7CA71D.8040009@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53449 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab1CMMyq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2011 08:54:46 -0400
In-Reply-To: <4D7CA71D.8040009@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-03-13 12:14, Pablo Neira Ayuso wrote:
>> 
>> I have observed a really odd issue, whereby running Linux 2.6.37.{0,1,2} 
>> would cause `conntrack -L` to show nothing despite 
>> /proc/net/nf_conntrack clearly having entries. Furthermore, the 
>> functionality is restored in Patrick's nf-next that currently carries 
>> 2.6.38-rc1, so there might have been a bug fix I am not aware about.
>> .config is the same in either case, and the nfnetlink modules are 
>> loaded.
>> 
>> (Unfortunately, bisecting between 2.6.37 and 38-rc1 is problematic 
>> because it can step through Nick Piggin's VFS changes that, at some 
>> points, can cause an oops.)
>
>Does cba85b532e4aabdb97f44c18987d45141fd93faa fix your problem?

It does, thanks.
