From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: [netfilter-core] asymptotic complexity when creating new chains
 and rules
Date: Mon, 5 Jan 2004 11:11:33 -0200 (BRST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0401051055260.27269-100000@fantomas.insite.com.br>
References: <20040104043038.16CC32C2C1@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Stefan Winter <mail@stefan-winter.de>,
        "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20040104043038.16CC32C2C1@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 4 Jan 2004, Rusty Russell wrote:

> In message <200401031636.11291.mail@stefan-winter.de> you write:
> > But, if you iterate this process a hundred times (with increasing "N" in the 
> > chain name, so that you get 200 chains with 200*62 rules altogether), adding 
> > the chains slows down with every new chain (first chain: 20 ms, all chains 
> > together 150 SECONDS). This seems to imply that adding a chain (or rule) is 
> > of complexity O(n) with n being the number of rules/chains already in the 
> > table, where one would expect O(1). Is that right?
> 
> Yes.  In particular, the userspace is theoretically O(1), in that if
> you read the chains once, kept that copy, and every time updated it
> and committed it to the kernel, that would be O(1).  But most uses of
> libiptc do "read all rules, insert new one, repeat".  Secondly, the
> kernel isn't O(1): it checks for loops, and actually calls all the
> rules' matches and targets to check they like where they are.
> 
> This is why Harald is working on pkttables, which abandons the whole
> "flip the whole table into the kernel approach".

	Yeah, userspace should be O(1), but it is O(n). So,
iptables-restore is currently O(n^2), or better put, it is Theta(n^2).

	I resumed working on that (again) last week, based on the cvs
version of iptables, but I later noticed that on iptables-1.2.9 there is a
directory called libiptc2. I have a lot of work done on iptables cvs. What
is the status of libiptc2? I would like to keep on working on current line
of work (libiptc2 seems to use the same approach as I do).

	My personal take is that it is more or less easy to make iptables
more well behaved. The major problems are fallthrough rules (that have to
be identified, but after that, they are dealt with trivially) and the
different ways targets are expressed in different places (by offsets or by
names). After dealing with those, most of the complexity of the libiptc
package is gone. No more correct_verdict, alloc_handle, target_name,
entry2offset, etc, etc, etc. Appends become O(log n). With a hash table,
appends may become O(1). I think I can get something out this week.

	Happy new year to all,

	Andre

	
	

	
