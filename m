From: Mikael Pettersson <mikpe@csd.uu.se>
Subject: Re: [PATCH] x_tables: fix alignment on [at least] ppc32
Date: Fri, 20 Jan 2006 10:28:17 +0100
Message-ID: <17360.44337.425946.347577@alkaid.it.uu.se>
References: <17358.19458.555996.684819@alkaid.it.uu.se>
	<20060118150158.GL4603@sunbeam.de.gnumonks.org>
	<20060120004512.GT4603@sunbeam.de.gnumonks.org>
	<20060119.165635.104653932.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750710AbWATJ3T@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060119.165635.104653932.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David S. Miller writes:
 > From: Harald Welte <laforge@netfilter.org>
 > Date: Fri, 20 Jan 2006 01:45:12 +0100
 > 
 > > [NETFILTER] x_tables: Fix XT_ALIGN() macro on [at least] ppc32
 > > 
 > > To keep backwards compatibility with old iptables userspace programs,
 > > the new XT_ALIGN macro always has to return the same value as IPT_ALIGN,
 > > IP6T_ALIGN or ARPT_ALIGN in previous kernels.
 > > 
 > > However, in those kernels the macro was defined in dependency to the
 > > respective layer3 specifi data structures, which we can no longer do with
 > > x_tables.
 > > 
 > > The fix is an ugly kludge, but it has been tested to solve the problem. Yet
 > > another reason to move away from the current {ip,ip6,arp,eb}tables like
 > > data structures.
 > > 
 > > Signed-off-by: Harald Welte <laforge@netfilter.org>
 > 
 > Harald, I'm going to modify this to just use u_int64_t as that
 > should be totally sufficient.

ACK. Both Harald's patch and DaveM's simplification of it
(simply s/void */u_int64_t/g in XT_ALIGN()) fix the iptables
problems on my ppc32 box.

/Mikael
