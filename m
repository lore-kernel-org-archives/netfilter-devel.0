From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_acct: use skb->len for accounting
Date: Mon, 02 Aug 2010 17:56:53 +0200
Message-ID: <4C56EAC5.2060601@trash.net>
References: <1279856399-9058-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1279856399-9058-1-git-send-email-xiaosuo@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 23.07.2010 05:39, Changli Gao wrote:
> use skb->len for accounting as xt_quota does. Since nf_conntrack works at
> the network layer, skb_network_offset should always returns ZERO.

Applied.
