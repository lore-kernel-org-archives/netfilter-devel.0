From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Netfilter transparent proxying support
Date: Wed, 7 Apr 2004 11:12:55 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404071105150.23491-100000@filer.marasystems.com>
References: <1081324098.1192.8.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1081324098.1192.8.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 7 Apr 2004, KOVACS Krisztian wrote:

>   - patches which modify the IP core:
>     - 01-net-protocol_callbacks.patch: adds two hooks to the UDP and TCP
>         protocol implementation, making implicit unassign operations when
>         closing an assigned socket possible. These are really ugly, but
> 	seem to be the only possible solution.

This is to allow proper syncronisation between conntrack and kernel on 
open/closed connections, right?

I agree that a closer relation between TCP/IP stack and conntrack is
required on local connections. I would prefer if they were tightly bound,
even forcing the conntrack to stay until the local socket dies (after
time_wait). The stack does a good job in socket state management, much
more precise than conntrack can ever realistically become and not
utilising this where available is a waste in my opinion.

>     - 06-netfilter-export_nat_lock.patch: exports the NAT lock, which is
>         needed by iptable_tproxy to be able to use ip_nat_setup_info().

I also need this in some of my experimental NAT related things.

>     - 07-netfilter-extend_conntrack_struct.patch: this patch extends the
>         ip_conntrack structure, adding an extra list_head, and specifying
>         two new bits in the status field. The list_head is used by tproxy
>         to make fast deletion of conntrack entries possible, which is
>         needed in some cases when unassigning/closing a socket.

Please elaborate. I guess this goes together with 
01-net-protocol_callbacks.patch?

Regards
Henrik
