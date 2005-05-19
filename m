From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [Patch] ip{,
	6}tables-restore -n with existing user defined chain
Date: Thu, 19 May 2005 18:37:23 +0200
Message-ID: <428CC0C3.9000203@gmx.net>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
	<428CB43E.5060503@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <428CB43E.5060503@outerspace.dyndns.org>
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

Jonas Berlin schrieb:
> Quoting Charlie Brady on 2005-05-18 16:07 UTC:
> 
>>>I want to redefine an existing chain atomically. I can't do that with
>>>the iptables command, but can almost do it with iptables-restore -n.
>>>When I try, iptables barfs because the chain already exists. Duh! Yeah,
>>>I know it exists, but I want to redefine it.
> 
> 
> One option is to make a new version with a new name and then atomically
> replace jumps to the old version to use the new version:

What about atomic rename instead?


> original setup:
> 
>   iptables -N INPUT0
>   iptables -A INPUT0 ...
>   ...
>   iptables -N FOOBAR0
>   iptables -A FOOBAR0...
>   iptables -A INPUT0 ... -j FOOBAR0
>   ...
>   iptables -A INPUT -j INPUT0
> 
> switch to new:
> 
>   iptables -N tmp0
>   iptables -A tmp0 ...
>   ...
>   iptables -N tmp1
>   iptables -A tmp1...
>   iptables -A tmp0 ... -j tmp1
>   ...
iptables --exchange-names tmp0:INPUT0,tmp1:FOOBAR0

>   # cleanup (could be replaced by some automatic loop finding all chains
>   #          named something ending in "0")
>   iptables -F tmp0
>   iptables -X tmp0
>   iptables -F tmp1
>   iptables -X tmp1

What do you think?

Regards,
Carl-Daniel
