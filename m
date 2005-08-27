From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] New ipt_TTL target
Date: Fri, 26 Aug 2005 20:53:34 -0700 (PDT)
Message-ID: <20050826.205334.62987511.davem@davemloft.net>
References: <20050826183151.GD4226@rama.de.gnumonks.org>
	<20050826.123018.21840974.davem@davemloft.net>
	<430FDE74.7030800@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <430FDE74.7030800@trash.net>
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
Date: Sat, 27 Aug 2005 05:31:00 +0200

> If we want to make sure, we simply print a message in the iptables
> userspace command when someone uses this option. If this is too
> extreme, a comment in the man-page will probably help to reach more
> people than in the kernel-help text.

Whatever you guys think works best.
