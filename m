From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: 2.6.20 support for other 'features'
Date: Mon, 16 Apr 2007 22:02:06 +0900 (JST)
Message-ID: <200704161302.l3GD27fu009396@toshiba.co.jp>
References: <461D2748.4050000@trash.net>
	<e6af3bc80704121549g44dfb1bct8a8a735a2d6dc67f@mail.gmail.com>
	<461F0585.9030103@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: mmohsenz@gmail.com, netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461F0585.9030103@trash.net>
	<461D2748.4050000@trash.net>
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


Hi,

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 13 Apr 2007 06:22:29 +0200

> > One problem that I can see with this is that we have flush all our
> > conntracks so we can call     kmem_cache_destroy and then recreate the
> > slab with new size. Would this be alright since it would only happen
> > on registering and unregistering features since it doesn't happen
> > often.
> 
> 
> No, I don't like that, besides a single slab cache would force us to
> waste space by always allocating the maximum size even if not needed
> for a specific conntrack (helpers for example are rare).

And that is too complicated to reallocate conntrack and restructure
relationship among them. That's why the current nf_connrack doesn't
reallocate conntrack even if NAT and all helper modules are unloaded.


>                                                          Rusty had a
> better idea, search the archives for ct_extend.

In the current, I think that ct_extend is the best way to manage memory
space for conntrack.

IIRC he said that more benchmarks are necessary, but anyway, I'll look his
code again. I think we can improve his code more.

-- Yasuyuki Kozakai
