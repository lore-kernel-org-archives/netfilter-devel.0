From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: New match ipt_nexthop
Date: Wed, 15 Sep 2004 21:20:32 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4148EA60.6000106@cookinglinux.org>
References: <4148ABD0.9070203@cookinglinux.org> <4148B820.3040301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4148B820.3040301@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

>>
>>
>> Bad and good comments are welcome!
>
>
>
> We already have the realm match in the kernel, which matches the
> routing realms. Is there anything you can't do with the realm
> match but with your new match ?

No, there isn't.
The realm match seems to do much more than what this new match can.
However, nexthop match doesn't require those realms routing keys and is
quite simple to set up.

router A : 192.168.0.1
router B : 192.168.0.2

iptables -A FORWARD -m nexthop --nexthop-ip 192.168.0.1 -j LOG 
--log-prefix "Processed by A: "
iptables -A FORWARD -m nexthop --nexthop-ip 192.168.0.2 -j LOG 
--log-prefix "Processed by B: "

I think it's not a question of functionnality, but simplicity.

Conclusion, I find this new match useless being given that realm match 
can all do that.

>
> Regards
> Patrick
>
>
Cheers,

Samuel Jean
CookingLinux.org
