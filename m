From: Willy Tarreau <willy@w.ods.org>
Subject: faster way to read conntrack state than /proc ?
Date: Sat, 18 Oct 2003 09:42:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031018074256.GA29942@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@redhat.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

On LKML, to someone complaining about the slowness of /proc/net/tcp, Davem
suggested to use the netlink interface instead which was really faster. BTW,
the guy confirmed that 'ss' took 6 seconds where 'netstat' took 15 min. So
I was wondering if there is such an equivalent for /proc/net/ip_conntrack,
and if not, what would be needed to implement it, because it's sometimes
annoying to eat 100% system on production machines during several minutes
just to get some statistics about connections status.

Anyone has a clue on this ?

Cheers,
Willy
