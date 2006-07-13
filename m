From: David Miller <davem@davemloft.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 12 Jul 2006 17:42:27 -0700 (PDT)
Message-ID: <20060712.174227.126763959.davem@davemloft.net>
References: <44AF200F.9000204@trash.net> <44B493BC.5010302@snapgear.com>
	<44B591C5.8080604@shorewall.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, bdschuym@pandora.be,
	philipc@snapgear.com, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: teastep@shorewall.net
In-Reply-To: <44B591C5.8080604@shorewall.net>
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

From: Tom Eastep <teastep@shorewall.net>
Date: Wed, 12 Jul 2006 17:20:21 -0700

> From what I gather, ebtables doesn't support ULOG so that
> form of logging won't be available.

See net/bridge/netfilter/ebt_ulog.c, it does support this.
