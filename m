From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 12:03:08 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171156460.29541-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Jozsef Kadlecsik wrote:

> Thank you pointing out the article! Let's consider the current version of
> ipset as the first, beta release (as it is :-). Actually, Linus'
> description when vmalloc is valid fits to the vmalloc usage in ipset
> (large arrays allocated), but I'll work on to eliminate it.

To make you more comfortable it may be worth noticing that iptables too 
uses vmalloc for allocating the iptables.

What can be argued is that any design requiring allocation of a large
contigous memory areas in the kernel is broken by design and should be
redesigned rather than referring to vmalloc, and I think this is what
Linus tried to say. In my opinion a design which frequently calls vmalloc 
is plain broken, but a design intentionally requiring a large allocation 
should use vmalloc providing the design as such is valid.

Regards
Henrik
