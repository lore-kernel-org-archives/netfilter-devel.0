From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 10:38:55 +0100
Message-ID: <47A2E8AF.7070609@trash.net>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.400747893@kruemel.intranet.astaro.de> <47A27481.7080700@netfilter.org> <47A2E1EF.8000006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org,
	holger@eitzenberger.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42479 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYBAJjB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:39:01 -0500
In-Reply-To: <47A2E1EF.8000006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> heitzenberger@astaro.com wrote:
>>> Also implement garbage collection to account for the fact that netlink
>>> messages are sometimes lost (ENOBUFS) on busy sites.
>>
>> Well, this NFCT stuff is a big hack. I'm sure that you have solved
>> several issues with those patches but sorry, I don't like them at all.
>> There's several parts of conntrackd that we could use to rework this eg.
>> an implementation of a generic hash table in conntrackd that we can
>> reuse and nfnl_recv_msgs looks very similar to nfnl_catch, etc. Also,
>> the ENOBUFS handling is still a mess. I'm better keeping back these NFCT
>> patches. I'll try to give some spins to it.
>>
> 
> What exactly are your objections? From what I can see it simply
> improves performance of the existing code and cleans it up a bit.


Generally speaking, conntrackd doesn't matter here in my opinion,
features are either present in the libraries or have to be implemented
in users of the same. Demanding that code uses foreign non-library
code in a execve-fashion is just not reasonable.
