From: Patrick McHardy <kaber@trash.net>
Subject: Re: latest nf_conntrack version
Date: Wed, 03 Aug 2005 23:22:45 +0200
Message-ID: <42F135A5.5070300@trash.net>
References: <200508021633.j72GX9Ea016932@toshiba.co.jp>	<42EFEA57.5010406@trash.net>	<20050803142708.GA9456@rama.de.gnumonks.org>
	<200508032114.j73LEkfa028999@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200508032114.j73LEkfa028999@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> The configuration menu for netlink and nf_conntrack in your branch are in
> "Packet Generator" menu.

I think the reason for this is the CONFIG_NET_CLS_ROUTE option. For some
reason menuconfig gets things wrong in this case.

Regards
Patrick
