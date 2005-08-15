From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 1/4]: Remove two unused files
Date: Sun, 14 Aug 2005 17:35:22 -0700 (PDT)
Message-ID: <20050814.173522.32215162.davem@davemloft.net>
References: <42FFC91E.9090806@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42FFC91E.9090806@trash.net>
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
Date: Mon, 15 Aug 2005 00:43:42 +0200

> following a three minor patches and one patch to finally
> remove the broken cmd/sid and pid matching from ipt_owner.
> Users probably won't be happy, but I don't see a chance for
> fixing it and apparently it is beginning to stand in the
> way of other changes.

All 4 patches applied to net-2.6.14, thanks.

I'm glad to see that whole ipt_owner issue finally resolved :-)
