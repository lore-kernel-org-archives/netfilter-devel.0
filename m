From: Patrick McHardy <kaber@trash.net>
Subject: Re: Tproxy4, fwmark and netfilter route_me_harder
Date: Sun, 20 Jan 2008 16:31:11 +0100
Message-ID: <4793693F.4080604@trash.net>
References: <2eda2a0a0801101228h230e9d56pd850df9e86a03546@mail.gmail.com> <47878108.50108@redtone.com> <2eda2a0a0801101928l650804aclbdfd101779f45295@mail.gmail.com> <007901c85403$6f690dd0$8119fea9@MingChing> <47873A67.2010406@balabit.hu> <47878F45.4040201@redtone.com> <47879DC5.3050605@balabit.hu> <47883860.8040303@redtone.com> <20080115114237.GA7265@sch.bme.hu> <478F724F.8010900@redtone.com> <007001c858b0$9f570db0$8119fea9@MingChing>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu
To: Ming-Ching Tiew <mingching.tiew@redtone.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60419 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYATPcP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 10:32:15 -0500
In-Reply-To: <007001c858b0$9f570db0$8119fea9@MingChing>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ming-Ching Tiew wrote:
> I  sort of just forward this to netfilter-devel.
>  
> For those who in netfilter-devel but not in tproxy mail list, a little 
> background here :-
>  
> I discovered after applying the tproxy4 patch which allows one to spoof 
> originating traffic with a foreign IP address ( for the purpose of doing 
> transparent proxy ) that after doing it, traffics with foreign IP will 
> not leave the system if there is a FWMARK in the mangle table OUTPUT 
> chain. Any MARK will screw up the routing.
>  
> And the patch above seems to be able to get the packets out of the machine
> again.
> 
> So the motivation here perhaps someone here could throw some light as to 
> how this situation is best handled.


IIRC the current TPROXY patches use a flag in the dst_entry
to indicate that the source address is non-local. So
ip_route_me_harder should probably check that flag and
use routing for foreign addresses for that case.
