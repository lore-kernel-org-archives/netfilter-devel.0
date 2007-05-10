From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/09]: nf_nat: remove unused argument of function
 allocating binding
Date: Thu, 10 May 2007 14:14:53 -0700 (PDT)
Message-ID: <20070510.141453.94072260.davem@davemloft.net>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
	<20070510134030.8559.58054.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134030.8559.58054.sendpatchset@localhost.localdomain>
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
Date: Thu, 10 May 2007 15:41:12 +0200 (MEST)

> [NETFILTER]: nf_nat: remove unused argument of function allocating binding
> 
> nf_nat_rule_find, alloc_null_binding and alloc_null_binding_confirmed
> do not use the argument 'info', which is actually ct->nat.info.
> If they are necessary to access it again, we can use the argument 'ct'
> instead.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
