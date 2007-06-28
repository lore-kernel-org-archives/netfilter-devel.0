From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [ANNOUNCE] Release of iptables 1.3.8
Date: Thu, 28 Jun 2007 20:39:55 +0900 (JST)
Message-ID: <200706281139.l5SBdu4c006703@toshiba.co.jp>
References: <467FC146.3040801@netfilter.org> <467FCECA.5060302@blue-labs.org>
	<4680DAB6.9000903@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, david@blue-labs.org,
	pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4680DAB6.9000903@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


From: Patrick McHardy <kaber@trash.net>
Date: Tue, 26 Jun 2007 11:21:58 +0200

> >>I did so and removed -DKERNEL_64_USERSPACE_32 from the Makefile and it worked.
> > 
> > 
> > Any comments from netfilter team on this?
> 
> 
> Indeed, thanks for the reminder. The KERNEL_64_USERSPACE_32 stuff
> needs to go.
> 
> Patches for that are welcome.

How state on this is ? If anyone doesn't do it until I come from dinner,
I'll take it. It conflicts some of xtasble patches I've updated.

-- Yasuyuki Kozakai
