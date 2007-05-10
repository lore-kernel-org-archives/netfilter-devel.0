From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 05/09]: ctnetlink: clear helper area and handle
 unchanged helper
Date: Thu, 10 May 2007 14:16:05 -0700 (PDT)
Message-ID: <20070510.141605.75759461.davem@davemloft.net>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
	<20070510134034.8559.94686.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134034.8559.94686.sendpatchset@localhost.localdomain>
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
Date: Thu, 10 May 2007 15:41:16 +0200 (MEST)

> [NETFILTER]: ctnetlink: clear helper area and handle unchanged helper
> 
> This patch
> - Clears private area for helper even if no helper is assigned to
>   conntrack. It might be used by old helper.
> - Unchanges if the same helper as the used one is specified.
> - Does not find helper if no helper is specified. And it does not
>   require private area for helper in that case.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
