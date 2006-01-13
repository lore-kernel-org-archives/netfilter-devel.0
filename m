From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] ctnetlink: Make expect events work
Date: Fri, 13 Jan 2006 11:54:58 +0100
Message-ID: <43C78702.1020807@ingate.com>
References: <43C6A946.5070009@ingate.com> <43C6F256.7040306@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43C6F256.7040306@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Marcus Sundberg wrote:
> 
>>expectation events are improperly tagged in the current ctnetlink
>>code, this patch makes them work.
> 
> Please, be more accurate with your descriptions. The expectation events
> are working just fine since NFNL_SUBSYS_CTNETLINK and
> NFNL_SUBSYS_CTNETLINK_EXP messages are handled similarly by
> libnetfilter_conntrack.
> 
> I agree that it's improperly tagged, so I like the change, but it's not
> a fix and it shouldn't go to -stable, it's a cleanup. Thanks!

Hi,

I disagree with that. libnetfilter_conntrack happens to work because
it uses a different handler callback depending on what kind of data
it *expects* to receive, and lacks a check for what kind of data it
actually *is* receiving.

Without properly checking the subsystem there is no way of *knowing*
whether type 0 and attribute 1 in a netlink reply means IPCTNL_MSG_CT_NEW
and CTA_TUPLE_ORIG or if they mean IPCTNL_MSG_EXP_NEW and CTA_EXPECT_MASTER.
You can only guess based on what netlink requests you have previously
sent to the kernel and your knowledge about current kernel internals.

It may work, but it's not the way to make robust APIs.

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
