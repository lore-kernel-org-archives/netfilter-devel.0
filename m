From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/04]: ipt_DNAT: accept port randomization option
Date: Thu, 03 May 2007 03:34:13 -0700 (PDT)
Message-ID: <20070503.033413.130139791.davem@davemloft.net>
References: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
	<20070503012439.12818.28836.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503012439.12818.28836.sendpatchset@localhost.localdomain>
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
Date: Thu,  3 May 2007 03:25:57 +0200 (MEST)

> [NETFILTER]: ipt_DNAT: accept port randomization option
> 
> Also accept the --random option for DNAT to allow randomly selecting a
> destination port from the given range.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
