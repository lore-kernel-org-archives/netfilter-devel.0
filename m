From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 0/3] change TCP protoinfo via netlink
Date: Thu, 25 Aug 2005 22:42:28 +0200
Message-ID: <430E2D34.3030704@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Taken from [1]:

I think that users must be able to set the TCP state of a conntrack,
otherwise if they create a conntrack via libnfnetlink_conntrack, the
state will be set to NONE. If users aren't able to set the state, I'd
consider that the library is kind of incomplete. I don't like the idea
of kidding with stuff that could be compromising either, but I don't
want to lose any features. So, I think that the solution is *remark* in
the documentation of libnfnetlink_conntrack and the conntrack manpage
that changing the protocol private information like the state could
result in problems, I'll to do such thing.

[1]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020784.html

@Harald: I've reworked the patches as you suggested.

--
Pablo
