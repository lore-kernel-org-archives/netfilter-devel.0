From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error and memory leak?
Date: Sun, 21 Sep 2003 22:03:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1064174583.28578.106.camel@tux.rsn.bth.se>
References: <3F65EC33.2060906@wp.pl>
	 <1064059876.2500.54.camel@tux.rsn.bth.se>
	 <20030921150458.GE22223@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: c0g <c0g@wp.pl>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030921150458.GE22223@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-09-21 at 17:04, Harald Welte wrote:

> Mh. So why does it call get_tuple() anyway?  To check if the tuple is
> taken (i.e. the packet is part of an already tracked connection)?  I
> think we can safely split this check, since
> 
> 1) it tries to work around an obvious misconfiguration by the user
> 2) it adds significant runtime cost to the NOTRACK target (call
>    get_tuple, which calls in turn the l4 protocol helper get_tuple, then
>    tuple_taken(), which in turn locks the conntrack lock, ...)
> 3) it introduces the problem above.
> 
> Yes, we can still try to make it work, even with that check.  But I
> think we can just skip it and make our life easier.

That's how it used to work but that wasn't Jozsef's intentions with the
target iirc.

> btw: I wan to merge the 'raw' table userspace changes into iptables
> before 1.2.9 is released... All we need to make it compile even on a
> non-rawtable-kernel is:
> 
> #ifndef IPT_CONNTRACK_STATE_UNTRACKED
> #define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_IS_REPLY+3))
> #endif
> 
> in one of our (userspace) header files.

This creates a problem with p-o-m.
If we release a new p-o-m version before 1.2.9 is released it will
contain the userspace part of the raw patch. Then when 1.2.9 is released
it will already be patched with that patch and p-o-m will fail.

-- 
/Martin
