From: "David S. Miller" <davem@davemloft.net>
Subject: Re: BUG: atomic counter underflow at
 ip_conntrack_event_cache_init+0x91/0xb0 (with patch)
Date: Fri, 05 Aug 2005 02:06:01 -0700 (PDT)
Message-ID: <20050805.020601.74738947.davem@davemloft.net>
References: <42EEC2BB.3020105@trash.net>
	<20050802132922.GA3834@inferi.kami.home>
	<42F10E51.9000605@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: malattia@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42F10E51.9000605@trash.net>
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
Date: Wed, 03 Aug 2005 20:34:57 +0200

> [NETFILTER]: Fix multiple problems with the conntrack event cache

Applied to net-2.6.14, thanks Patrick.
