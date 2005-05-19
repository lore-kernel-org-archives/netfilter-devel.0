From: Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au>
Subject: Re: [Patch] ip{,
	6}tables-restore -n with existing user defined chain
Date: Thu, 19 May 2005 11:57:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0505191153080.15090@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
	<428CB43E.5060503@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


On Thu, 19 May 2005, Jonas Berlin wrote:

>  iptables -N FOOBAR1
>  iptables -A FOOBAR1...
>  iptables -A INPUT1 ... -j FOOBAR1
>  ...
>  iptables -R INPUT 1 -j INPUT1
>  # cleanup (could be replaced by some automatic loop finding all chains
>  #          named something ending in "0")
>  iptables -F INPUT0
>  iptables -X INPUT0
>  iptables -F FOOBAR0
>  iptables -X FOOBAR0
>
> It would probably be rather easy to create some wrappers that manage the
> versioning.. Also, two versions would be enough (0 and 1).

Yes, indeed. That's exactly the code that I'm trying to replace with 
something neater and waaaaaay quicker. :-)

> I might just go ahead and try something like this myself, actually.. :)

By all means. Then do 1-to-1 DNAT of a 3000 port block range, on a low end 
processor. Then you'll know why I've proposed this particular change, 
which I think will inconvenience no-one.

Regards

---
Charlie
