From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack tree
Date: Wed, 23 Mar 2005 01:31:22 +0900 (JST)
Message-ID: <200503221631.j2MGVMB8011775@toshiba.co.jp>
References: <42389136.3050900@trash.net>
	<200503170831.j2H8VgbY014017@toshiba.co.jp>
	<423DA811.3090608@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
In-Reply-To: <423DA811.3090608@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 20 Mar 2005 17:42:57 +0100

> > But in the current, it's not acceptable to introduce nf_conntrack_common
> > as you said in other mail. I think it needs many changes to ip_conntrack and
> > ip_nat, it may be difficult to change nf_conn structure
> > (e.g. optimization), and it will confuse us - What we unify is ?
>
> We're unifying things common to ip_conntrack and nf_conntrack, like
> mark, status, ... in order to keep the number of accessor functions
> in nf_ct_ops to a minimum.

It's very poor joke. Please don't mind. :)

At first, let me clarify. I imagine that your suggestion is changing definition
of "struct ip_connntrack" as follow.

struct ip_conntrack {
	...
	struct nf_conntrack_common common;
	...
}

This would change many parts of ip_conntrack and we'd have to rework on this
issue when we want to change some member of "struct nf_conn". I think
duplicating matches/targets is better than this way.

Or what you suggest is implementing glue function which gathers the common
parameters from ip_conntrack/nf_conn and put them in nf_conntrack_common
structure ? This introduces a few overheads, but acceptable for me.

> Yes, that is one part. But some matches/targets need to get some
> information from the conntrack. I've made a list of what is needed, so
> we can talk in more concrete terms:

OK,

> ipt_state:
> - recognize untracked
> 
> ipt_helper:
> - ct->master->helper->name
> 
> ipt_conntrack:
> - recognize untracked
> - tuples
> - status
> - expires
> 
> ipt_connmark/IPT_CONNMARK:
> - mark

We have to be careful about "mark". Users may enable NF_IP_CONNTRACK_MARK and
disable NF_CONNTRACK_MARK.

> Creating a struct nf_conntrack_common should be ok for untracked,
> status, expires, mark and master->helper->name. The tuples can't be
> handled this way, for them we need nf_ct_ops.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
