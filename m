From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] ctnetlink: Make expect events work
Date: Fri, 13 Jan 2006 01:20:38 +0100
Message-ID: <43C6F256.7040306@eurodev.net>
References: <43C6A946.5070009@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <43C6A946.5070009@ingate.com>
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

Marcus Sundberg wrote:
> expectation events are improperly tagged in the current ctnetlink
> code, this patch makes them work.

Please, be more accurate with your descriptions. The expectation events
are working just fine since NFNL_SUBSYS_CTNETLINK and
NFNL_SUBSYS_CTNETLINK_EXP messages are handled similarly by
libnetfilter_conntrack.

I agree that it's improperly tagged, so I like the change, but it's not
a fix and it shouldn't go to -stable, it's a cleanup. Thanks!

-- 
Pablo
