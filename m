From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: i think this i a kernel bug
Date: Sat, 25 Oct 2003 22:04:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310252200490.14678-100000@filer.marasystems.com>
References: <1067098665.18990.1.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kaspars Zeme <Kaspars.Zeme@delfi.lv>
In-Reply-To: <1067098665.18990.1.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> > Oct 25 17:10:06 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tuplehash[IP_CT_DIR_REPLY]'(de7be444) not in &ip_conntrack_hash [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> > 
> > notes:
> > 
> > i  can  not show you /proc/modules because the box just hangs up after
> > some  time  and  i  can't  get  that information.

A long shot, but have you verified the memory of your box? Try memtest86..

You should be able to get /proc/modules from the console with the box 
disconnected from the network I think. If this is a conntrack bug the 
problem should only be seen if there is any traffic processed by 
conntrack.

Regards
Henrik
