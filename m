From: Matthew Strait <quadong@users.sourceforge.net>
Subject: Re: [PATCH] l7-filter for pom
Date: Mon, 23 Aug 2004 18:40:31 -0500 (CDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0408231825530.4521@localhost.localdomain>
References: <Pine.LNX.4.60.0408151944550.15521@localhost.localdomain>
 <20040819104443.GG3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
    l7-filter-developers@lists.sourceforge.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040819104443.GG3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> - Don't have printk() in per-packet codepath without net_ratelimit() or
>  you will be DoS'ed

The code should not print anything unless debugging is enabled.  I'm 
assuming that no one will enable debugging unless they are in a controlled 
environment.  And when debugging, it would be bad to have most of the 
messages dropped.  Is this still not ok in your view?

> - The number of packets for each direction is now accounted for if you
>  use the conntrack-acct patch (will show up in 2.6.9, is in
>  patch-o-matic), please use this value.

I see that conntrack-acct is 2.6 only.  I'd rather not lose 2.4 
compatibility.  Should I:

1) Put separate 2.4 and 2.6 patches in p-o-m, one of which uses 
conntrack-acct and one of which doesn't.  (Ugly.)

2) Only submit a 2.6 patch to you and maintain my 2.4 patch outside p-o-m. 
(Clunky.)

3) Ask for conntrack-acct to be made 2.4 compatible.  (Work for you.)

-matthew
