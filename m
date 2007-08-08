From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/03]: Netfilter fixes
Date: Tue, 07 Aug 2007 18:12:42 -0700 (PDT)
Message-ID: <20070807.181242.89281020.davem@davemloft.net>
References: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon,  6 Aug 2007 15:29:03 +0200 (MEST)

> these patches fix a few netfilter bugs: failure to load IPv4 connection tracking
> when loading the NAT module, an invalid return code in ctnetlink and a possible
> NULL pointer dereference in ipt_recent. I'll pass the NULL pointer fix to
> -stable once its upstream.
> 
> Please apply, thanks.

Applied, thanks Patrick.

I really wish those dependencies could be worked out in a nicer
way than calling NULL functions in the needed module.
