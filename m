From: Patrick McHardy <kaber@trash.net>
Subject: Re: New match ipt_nexthop
Date: Wed, 15 Sep 2004 23:46:08 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4148B820.3040301@trash.net>
References: <4148ABD0.9070203@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <4148ABD0.9070203@cookinglinux.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Samuel Jean wrote:

> Hi,
>
> Attached is a pom-ng style patch that makes possible to match the 
> next-hop ipv4 of a packet.


Please attach the plain files next time.

>
> Should work with both 2.4 and 2.6 but still in testing.
>
> Notice that, for an unknown reason, the 2.6 Kconfig.ladd is appended 
> to the end of Kconfig. I'll be quite happy if someone could fix it and 
> tell me what was wrong. (I'm sorry for the inconvenient.)
>
> Bad and good comments are welcome!


We already have the realm match in the kernel, which matches the
routing realms. Is there anything you can't do with the realm
match but with your new match ?

Regards
Patrick
