From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] NETFILTER ctnetlink: use ENOMEM instead of -1
Date: Sat, 08 Oct 2005 17:42:44 +0200
Message-ID: <4347E8F4.5010807@trash.net>
References: <20051007221948.GL4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20051007221948.GL4450@rama.customers.eurospot.com>
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

Harald Welte wrote:
> [NETFILTER] ctnetlink: use ENOMEM instead of -1 (-ENOPERM)
> 
> Fix the return value of NFA_PUT on fail. Now it returns -ENOMEM
> instead of -1 (-ENOPERM) since NFA_PUT only fails if there's no
> enough space in the netlink message for the new attribute that
> will be added. Thanks to Patrick McHardy for spotting this.

Actually this is not what I meant. On paths were NFA_PUT is used,
returning -1 is fine because the caller just checks for <0 to
notice an error and the error is not returned to userspace or
something. -ENOMEM is obviously wrong since there is no memory
allocation involved. What I meant was to not return -1 on
the receive path, where NFA_PUT isn't used, but to propagate
the real error from the function call before (I don't remember
which one it was).

Dave, please drop this patch.
