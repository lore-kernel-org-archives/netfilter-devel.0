From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 14:49:05 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0402171348210.1089@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0402171156460.29541-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402171156460.29541-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Henrik Nordstrom wrote:

> What can be argued is that any design requiring allocation of a large
> contigous memory areas in the kernel is broken by design and should be
> redesigned rather than referring to vmalloc, and I think this is what
> Linus tried to say. In my opinion a design which frequently calls vmalloc
> is plain broken, but a design intentionally requiring a large allocation
> should use vmalloc providing the design as such is valid.

Maybe try __get_free_pages() and fall back to vmalloc() if it fails?

The downside of __get_free_pages() is that you get 2^n pages of memory
which might result in a quite large allocation sometimes.

I've been using this in conntrack for some time and it works fine. I
havn't tried to measure any benefits. One thing I don't do is to increase
the hashsize if the wanted allocation would be for (2^n)+1 pages (then the
actual allocation will be for 2^(n+1) pages). Now with the jenkins hash we
don't have any problems with 2^n hashtable sizes so we could do that.

/Martin
