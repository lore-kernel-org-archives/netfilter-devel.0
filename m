From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/07]: nf_conntrack_ftp: fix newline sequence
 number calculation
Date: Thu, 24 May 2007 16:41:59 -0700 (PDT)
Message-ID: <20070524.164159.82356841.davem@davemloft.net>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
	<20070524215836.14308.55840.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215836.14308.55840.sendpatchset@localhost.localdomain>
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
Date: Fri, 25 May 2007 00:02:09 +0200 (MEST)

> [NETFILTER]: nf_conntrack_ftp: fix newline sequence number calculation
> 
> When the packet size is changed by the FTP NAT helper, the connection
> tracking helper adjusts the sequence number of the newline character
> by the size difference. This is wrong because NAT sequence number
> adjustment happens after helpers are called, so the unadjusted number
> is compared to the already adjusted one.
> 
> Based on report by YU, Haitao <yuhaitao@tsinghua.org.cn>
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
