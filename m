From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: the latest nf_conntrack
Date: Sat, 24 Jul 2004 17:21:43 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407240821.RAA21118@toshiba.co.jp>
References: <200407010617.PAA23966@toshiba.co.jp>
	<20040722032823.GS27487@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, netfilter-devel@lists.netfilter.org,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20040722032823.GS27487@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Harald,

Thanks for reviewing.

From: Harald Welte <laforge@netfilter.org>
Date: Wed, 21 Jul 2004 23:28:24 -0400

> On Thu, Jul 01, 2004 at 03:17:43PM +0900, Yasuyuki Kozakai wrote:
> > 
> > Hi, all,
> > 
> > This is pom-ng style patch which enables layer 3 independent connection
> > tracking (nf_conntrack). In nf_conntrack, core module is generalized so that
> > other layer 3 protocols are easily implemented. In now, IPv4, IPv6, TCP, UDP,
> > ICMP, ICMPv6 and FTP can be tracked.
> 
> Thanks, Yasuyuki.
> 
> I finally had the time for a review of your current code.  My
> congratulations to your work, everything looks very clean, and I do not
> have any comments at this time.

I'm so glad.

> Could you please post a list of current issues / problems / questions /
> ... that you might have with the current nf_conntrack code?

OK. current issues are following.

1. destroying slab cache
In current nf_conntrack, when all helper modules are unloaded,

	1. all conntracks used by them are copied to the cache from other slab
	2. old conntracks are freed.
	3. the slab for features of helpers are destroyed.

I think this is complex.

Ideally, destroying slab should be done when all conntrack are destroyed due to
natural reason (timeout, and so on). But we cannot do it because
kmem_cache_destroy() may sleep! So the current codes are better solution, but
I'm not sure in the future.

2. access reassembled IPv6 packets.
nf_ct_frag6_get_reasm() helps match functions which want to access to
the reassembled packet. But the contents in it may differ from fragments.
Because the contents of fragments may be changed after NF_IP6_PRE_ROUTING.

3. tuple of IPv6 fragmented packets.
In early nf_conntrack_proto_frag6.c, the tuple of IPv6 fragmented packets were

	- l3 protocol number (IPv6)
	- IPv6 source/destination addresses.
	- l4 protocol number (IPv6 Fragment)
	- 32bit fragment ID (from Fragment header)
		upper 16 bit is in src part of tuple, rest is in dst part.

In theory, this connection don't have replying packets, but init_conntrack()
requires it. I wrote frag6_invert_tuple() which just wrote the same ID to
inverse tuple. But this caused conflicts with the connection which had same
ID but in inverse direction. Then I introduced the new field "orig" into tuple.
This represent weather tuple is original direction or not.
The problem is solved but this requires more memory space to the l4 part
in tuple.

If the core module could confirm tuple_hash in the only original direction,
"orig" field was not needed. But I'm not sure that it make sense to change
core module for the only IPv6 fragmented packets.

4. duplicated codes of v4/v6 match modules which use conntrack informations.

This is not issue of nf_conntrack, but is related with it. ipt_state.ko and
ip6t_state.ko will be almost same code. One possible solution is 
to move almost codes to one module and to became ip(6)t_state.ko wrapper.
but I worry about increasing the number of modules.

> What amount of testing has it received so far (including ftp-helper,
> ...) ?

I did...

	- some tests about various timing of unloading helper module and
	  destroying slab cache.
	- tests about various pattern of fragments in detail.
	- some tests about l3/l4 protocol modules but not in detail.
	- some tests about ftp helper but not in detail. PASV, PORT, EPRT,
	  EPSV are tested with ftp and ftpd in usagi packages.
		- parsing IPv6 address are tested with various pattern, but
		  I'm not sure that's all pattern.

And I did'nt test on SMP machine.

> Is the state in patch-o-matic-ng the current state, or do you already
> have some more recent changes?

No. I didn't change it.

> I'm happy to give you CVS access to the nf_conntrack module in pom-ng,
> in case you want to push some updates into our tree.

Thanks! I'll ask for it when changing codes.

> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
