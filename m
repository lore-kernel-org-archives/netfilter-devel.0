From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: ctnetlink: fix deadlock in table dumping
Date: Thu, 17 Aug 2006 18:13:00 -0700 (PDT)
Message-ID: <20060817.181300.104034404.davem@davemloft.net>
References: <44E397CE.3030808@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <44E397CE.3030808@trash.net>
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
Date: Thu, 17 Aug 2006 00:10:22 +0200

> Fix a deadlock in ctnetlink (introduced early in 2.6.18-rc by myself).
> Please apply to 2.6.18.

Applied, thanks Patrick.
