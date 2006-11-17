From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] [NETFILTER 00/08]: Netfilter -stable fixes
Date: Thu, 16 Nov 2006 23:02:28 -0800
Message-ID: <20061117070228.GL1397@sequoia.sous-sol.org>
References: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, stable@kernel.org, davem@davemloft.net
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
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

* Patrick McHardy (kaber@trash.net) wrote:
> Following are backports of a few important netfilter fixes for -stable,
> fixing multiple bugs in the ip_tables compat layer, missing checks
> during ip_tables ruleset validation and a crash on arp_tables module
> unload/reload. Also included are two patches fixing incorrect Kconfig
> dependencies and a LVS NAT source routing fix.

Thanks, queued them all.
-chris
