From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/02]: ctnetlink: fix leak in
 ctnetlink_create_conntrack error path
Date: Mon, 15 Jan 2007 17:15:05 -0800 (PST)
Message-ID: <20070115.171505.104037618.davem@davemloft.net>
References: <20070115092251.22775.89608.sendpatchset@localhost.localdomain>
	<20070115092252.22775.28870.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20070115092252.22775.28870.sendpatchset@localhost.localdomain>
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
Date: Mon, 15 Jan 2007 10:22:52 +0100 (MET)

> [NETFILTER]: ctnetlink: fix leak in ctnetlink_create_conntrack error path
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
