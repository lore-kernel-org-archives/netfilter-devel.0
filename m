From: Patrick Schaaf <bof@bof.de>
Subject: Re: Where is conntrack in the iptables chain?
Date: Mon, 25 Aug 2003 13:43:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825114322.GG423@oknodo.bof.de>
References: <20030825112217.GF423@oknodo.bof.de> <20030825112904.17092.qmail@web13904.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030825112904.17092.qmail@web13904.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Yup.  Are there any examples of how to manipulate
> packets prior to conntrack, either as a loadable
> module or via iptables?  I seem to recall a patch
> which added raw tables that acted before anything else
> but do not recall which rev of iptables it acted on...

Hi again,

you want to look at the general netfilter hooks, and how their
priorities work. You can look at the iptables kernel source 
for inspiration, it's rather simple. In net/ipv4/netfilter,
grep for nf_register_hook, and look at the argument to
that function, usually a locally defined constant struct.
The conntrack hooking is in ip_conntrack_standalone.c.
Notice the NF_IP_PRI_CONNTRACK in the struct definition:
this is defined in include/linux/netfilter_ipv4.h, and
represents a numerical priority value; for each
hook that the core network stack runs, the hook
functions for all registered modules, are called
in numerically ascending priority order. Specifically,
NF_IP_PRI_CONNTRACK is the lowest, numerically -200,
so for your own hook, you'll need something even below
that value, e.g. -201.

all the best
  Patrick
