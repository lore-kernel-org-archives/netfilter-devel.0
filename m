From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/07]: nf_conntrack_ftp: fix newline sequence
 number update
Date: Thu, 24 May 2007 16:41:25 -0700 (PDT)
Message-ID: <20070524.164125.102140251.davem@davemloft.net>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
	<20070524215835.14308.87748.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215835.14308.87748.sendpatchset@localhost.localdomain>
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
Date: Fri, 25 May 2007 00:02:07 +0200 (MEST)

> [NETFILTER]: nf_conntrack_ftp: fix newline sequence number update
> 
> When trying to locate the oldest entry in the history of newline character
> sequence numbers, the sequence number of the current entry is incorrectly
> compared with the index of the oldest sequence number instead of the number
> itself.
> 
> Additionally it is not made sure that the current sequence number really
> is after the oldest known one.
> 
> Based on report by YU, Haitao <yuhaitao@tsinghua.org.cn>
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
