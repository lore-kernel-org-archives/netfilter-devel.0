From: Santiago Garcia Mantinan <netfilter-devel@manty.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Sun, 19 Jun 2005 00:12:16 +0200
Message-ID: <20050618221216.GB3182@pul.manty.net>
References: <20050618124359.39052.qmail@web52901.mail.yahoo.com>
	<20050618192541.GA27439@pul.manty.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Chris Rankin <rankincj@yahoo.com>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20050618192541.GA27439@pul.manty.net>
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

> I have sent this right now to the bridge list, I'm copying it here so that
> more info is available about this bug.

I have selected patches from 2.6.12 that I thought could be related to this
issue, and I have finaly identified this patch...

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b31e5b1bb53b99dfd5e890aa07e943aff114ae1c

as the patch causing the problem, I have reversed it on my kernel tree and
now the firewall is working again.

I have not really looked at what the patch does and how it does that, I have
just identified it as the one causing the break of this connection tracking
relating to the bridges.

It seems this is affecting more stuff than the connection tracking on
bridges, I have a friend also suffering problems relating to the firewall in
2.6.12 and nothing to do with the bridge, but he is not around now so I
cannot confirm it is due to this patch also. His problem may be something
related to loopback. I'll try to contact him tomorrow and tell him to test
with this patch reversed.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
