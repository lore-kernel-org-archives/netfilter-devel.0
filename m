From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] for several issues
Date: Sat, 27 Mar 2004 23:13:57 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403272253530.23501-100000@filer.marasystems.com>
References: <20040327211205.GB26945@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040327211205.GB26945@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 27 Mar 2004, Harald Welte wrote:

> Yes.  But isn't this optimization based on the assumption that
> 'is_confirmed()' is an atomic operation?  What if it gets confirmed on a
> second cpu, after is_confirmed() was called and before we refresh?
> 
> Am I missing something?

My understanding: 

If it is not confirmed it is not yet in the conntrack hash, as it is not 
yet in the conntrack hash there can only be a single packet referencing 
this ct, and if another packet is being processed on another CPU for the 
same session before it is confirmed you will have one ct per packet, both 
of which will be confirmed individually.

It is also my understanding that the same packet will not be processed by 
both CPUs at the same time. Only one CPU will confirm the packet (and the 
conntrack referenced by it).


Note: assured is a different thing, this can obviosuly happen 
concurrently and should be expected to happen.

> In principle you're right.  The question is, whether it's worth
> optimizing that case.  Maybe you can do a little analysis:  How many
> direct or indirect calleers of ip_conntrack_get (or __ip_conntrack_get)
> don't need ctinfo?  If it is just about connmark, I guess we can leave
> it like it is.  But if a reasonable number of callers doesn't need it,
> we could change it.

My feeling is that it would be better to make ip_conntrack_get an inline
and let the compiler nullify the ctinfo calculation where it is not
needed. The only reason I see for ip_conntrack_get not being an inline is
to have correct module dependencies which can almost ceratinly be solved
in a better way.

There is a few other callers that don't really need the ctinfo. Several of
the other iptables extensions we have made just needs the conntrack (see
ml archives), and in the tree there is

  ipt_connlimit
  ipt_connmark
  ipt_CONNMARK
  ipt_helper
  ipt_MASQUERADE (only used in IP_NF_ASSERT)
  ipt_NETMAP
  ipt_REDIRECT (only used in IP_NF_ASSERT)
  ipt_SAME


Some of these could go good with similar IP_NF_ASSERT as is used in
ipt_MASQUERADE and ipt_REDIRECT which is further evidence that the inline
approach is the best path if one wants to optimize away the use of ctinfo
when not needed.
 
Regards
Henrik
