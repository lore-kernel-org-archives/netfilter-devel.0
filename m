From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: Advance seq-file position in exp_next_seq()
Date: Mon, 13 Jun 2005 18:28:41 -0700 (PDT)
Message-ID: <20050613.182841.78708332.davem@davemloft.net>
References: <42AE2B45.7080106@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42AE2B45.7080106@trash.net>
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
Date: Tue, 14 Jun 2005 02:56:37 +0200

> a small fix for 2.6.12 if still possible: exp_next_seq() (used for
> /proc/net/ip_conntracK_expect) doesn't advance the seq-file position.
> I haven't tracked exactly why, but this makes the seq-file API show
> (n+1)*(n/2) entries, with the first one showed n times, the second
> one n-1 times, and so on.

I put this into my tree and will try to get it to Linus tonight.
