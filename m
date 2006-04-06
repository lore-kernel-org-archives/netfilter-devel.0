From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 04/12]: H.323 helper: move some function prototypes
 to ip_conntrack_h323.h
Date: Thu, 06 Apr 2006 14:13:51 -0700 (PDT)
Message-ID: <20060406.141351.22547966.davem@davemloft.net>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
	<20060406100458.17409.70510.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060406100458.17409.70510.sendpatchset@localhost.localdomain>
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
Date: Thu,  6 Apr 2006 12:04:58 +0200 (MEST)

> [NETFILTER]: H.323 helper: move some function prototypes to ip_conntrack_h323.h
> 
> Move prototypes of NAT callbacks to ip_conntrack_h323.h. Because the use of
> typedefs as arguments, some header files need to be moved as well.
> 
> Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
