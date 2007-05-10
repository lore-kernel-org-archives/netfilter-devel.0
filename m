From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 08/09]: iptable_raw: ignore short packets sent by
 SOCK_RAW sockets
Date: Thu, 10 May 2007 14:17:44 -0700 (PDT)
Message-ID: <20070510.141744.76776387.davem@davemloft.net>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
	<20070510134038.8559.13052.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134038.8559.13052.sendpatchset@localhost.localdomain>
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
Date: Thu, 10 May 2007 15:41:20 +0200 (MEST)

> [NETFILTER]: iptable_raw: ignore short packets sent by SOCK_RAW sockets
> 
> iptables matches and targets expect packets to have at least a full
> IP header and a valid header length. Ignore packets sent through
> raw sockets for which this isn't true as in the other tables.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
