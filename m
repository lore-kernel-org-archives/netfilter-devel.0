From: KOVACS Krisztian <hidden@balabit.hu>
Subject: ctnetlink NATINFO notification
Date: Tue, 03 Aug 2004 11:00:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1091523624.2458.7.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

  While hacking on ct_sync, I've found a suspicious code fragment in
ip_nat_core.c with the ctnetlink patch applied. At the end of
ip_nat_setup_info(), an event is generated that the NAT information was
changed:

	[...]
		   IP_NAT_MANIP_SRC, inv_tuple.src });
	IP_NF_ASSERT(info->num_manips <= IP_NAT_MAX_MANIPS);
}

ip_conntrack_event(IPCT_NATINFO, conntrack);

/* If there's a helper, assign it; based on new tuple. */
if (!conntrack->master)
	info->helper = LIST_FIND(&ip_nat_helpers, helper_cmp, struct ip_nat_helper *,
				 &reply);
/* It's done. */
info->initialized |= (1 << HOOK2MANIP(hooknum));


  However, as you can see, the event is generated even before updating
the initialized field of the NAT info structure of the conntrack, so
that when the notifier functions are called, the conntrack isn't fully
up-to-date yet. Wouldn't be better to call the nofifiers right before
the return statement?

-- 
 Regards,
   Krisztian KOVACS
