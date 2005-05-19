From: Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au>
Subject: Re: [Patch] ip{,	6}tables-restore -n with existing user defined
 chain
Date: Thu, 19 May 2005 12:46:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0505191241070.15090@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
	<428CB43E.5060503@outerspace.dyndns.org> <428CC0C3.9000203@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
In-Reply-To: <428CC0C3.9000203@gmx.net>
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


On Thu, 19 May 2005, Carl-Daniel Hailfinger wrote:

> Jonas Berlin schrieb:
>> Quoting Charlie Brady on 2005-05-18 16:07 UTC:
>>
>>>> I want to redefine an existing chain atomically. I can't do that with
>>>> the iptables command, but can almost do it with iptables-restore -n.
>>>> When I try, iptables barfs because the chain already exists. Duh! Yeah,
>>>> I know it exists, but I want to redefine it.
>>
>> One option is to make a new version with a new name and then atomically
>> replace jumps to the old version to use the new version:
>
> What about atomic rename instead?

That should be a different topic of discussion. Does anyone have any 
objection to the patch as posted? IOW, does anyone depend on the current 
semantics that calling "iptables-restore -n" with a definition of a 
user-defined chain which already exists should fail, rather than redefine 
the chain as specified in the script?

---
Charlie
