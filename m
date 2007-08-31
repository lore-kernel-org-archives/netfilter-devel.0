From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: xt_tcpudp: fix wrong struct in udp_checkentry
Date: Thu, 30 Aug 2007 22:36:52 -0700 (PDT)
Message-ID: <20070830.223652.10542238.davem@davemloft.net>
References: <46D66BE9.5040304@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D66BE9.5040304@trash.net>
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
Date: Thu, 30 Aug 2007 09:04:09 +0200

> Hi Dave,
> 
> the attached patch fixes an incorrectly used structure
> in xt_tcpudp, which apparently causes problems on CRIS.
> 
> Please apply, thanks.

Applied, thanks Patrick.
