From: David Miller <davem@davemloft.net>
Subject: Re: [NETFITER 00/03]: Netfilter fixes/cleanup
Date: Tue, 24 Jul 2007 15:31:19 -0700 (PDT)
Message-ID: <20070724.153119.108742298.davem@davemloft.net>
References: <20070724155342.18487.35001.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070724155342.18487.35001.sendpatchset@localhost.localdomain>
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
Date: Tue, 24 Jul 2007 17:54:12 +0200 (MEST)

> These patches fix a log target regression in 2.6.22, causing failures to
> load ipt_LOG/ ipt_ULOG when the other one is already loaded and clean
> up a couple of duplicate includes. I'll send the regression fix to -stable
> once its upstream.
> 
> Please apply, thanks.

Applied, thanks Patrick.
