From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [BUG] ipt_SAME rule can't be deleted
Date: Tue, 7 Dec 2004 16:47:26 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412071644210.1650@filer.marasystems.com>
References: <20041204150223.GA10247@dfbbb.opencjk.org>
	<Pine.LNX.4.61.0412060821280.10926@filer.marasystems.com>
	<41B5A1C7.5060608@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Fang Han <fanghan@opencjk.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41B5A1C7.5060608@eurodev.net>
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

On Tue, 7 Dec 2004, Pablo Neira wrote:

> In iptables, target_difference() complains because, in the case of ipt_same, 
> iparray isn't NULL. Same thing with iplimit. I think that in pkttables we 
> need a private info part for match/targets which is not shared with user 
> space.

As already pointed out iptables actually have a similar concept, but the 
kernel data must be at the end, and userspace must know the total size to 
allocate it properly within the table..

limit uses this correctly.

SAME does not.

In addition, pointers is hazardous as the opinion on the size may differ 
between kernel and userland on certain architectures. Only fixed size 
items should be used in iptables target/match info structures. C unions 
can make this somewhat manageable.

Regards
Henrik
