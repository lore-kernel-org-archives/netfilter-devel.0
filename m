From: Patrick Schaaf <bof@bof.de>
Subject: Re: Preroute selection order
Date: Mon, 17 Feb 2003 09:58:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030217085815.GG7631@oknodo.bof.de>
References: <003901c2d0b3$f9fce8a0$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Andrew.hall" <temp02@bluereef.com.au>
Content-Disposition: inline
In-Reply-To: <003901c2d0b3$f9fce8a0$2601010a@bluereef.local>
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

> When writing (for example) a new table, can someone please tell me how
> netfilter orders the tables that register to listen on a particular hook
> such as PREROUTE? I assume that there is a defined pecking order to which
> tables get accessed first?

When writing a new table, you will eventually call nf_register_hook()
with a 'struct nf_hook_ops' that you populate. One of the fields of
that struct is called X, and if you grep for 'nf_hook_ops' in the
existing table implementations, you will find that this field is
usually initialized by a macro starting with NF_IP_PRI_*.
Finally, grepping for those macros, you will find an include
file with all the real values.

The hook functions are called in priority order, from numerically
lowest to numerically highest.

best regards
  Patrick

bof@cdr:~/src/linux-2.5-current$ find . -name '*.c' | xargs grep -l NF_IP_PRI
./net/bridge/br_netfilter.c
./net/ipv4/netfilter/ip_conntrack_standalone.c
./net/ipv4/netfilter/ip_fw_compat.c
./net/ipv4/netfilter/ip_nat_standalone.c
./net/ipv4/netfilter/iptable_filter.c
./net/ipv4/netfilter/iptable_mangle.c
./net/sched/sch_ingress.c
bof@cdr:~/src/linux-2.5-current$ find . -name '*.h' | xargs grep -l NF_IP_PRI
./include/linux/netfilter_ipv4.h
