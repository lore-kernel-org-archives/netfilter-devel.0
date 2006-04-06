From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 11/12]: Add address family specific checksum helpers
Date: Thu, 06 Apr 2006 14:18:52 -0700 (PDT)
Message-ID: <20060406.141852.98287210.davem@davemloft.net>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
	<20060406100508.17409.68682.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060406100508.17409.68682.sendpatchset@localhost.localdomain>
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
Date: Thu,  6 Apr 2006 12:05:08 +0200 (MEST)

> [NETFILTER]: Add address family specific checksum helpers
> 
> Add checksum operation which takes care of verifying the checksum and
> dealing with HW checksum errors and avoids multiple checksum operations
> by setting ip_summed to CHECKSUM_UNNECESSARY after successful verification.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
