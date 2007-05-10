From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/09]: Clean up table initialization
Date: Thu, 10 May 2007 14:14:24 -0700 (PDT)
Message-ID: <20070510.141424.31751194.davem@davemloft.net>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
	<20070510134028.8559.53451.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134028.8559.53451.sendpatchset@localhost.localdomain>
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
Date: Thu, 10 May 2007 15:41:11 +0200 (MEST)

> [NETFILTER]: Clean up table initialization
> 
> - move arp_tables initial table structure definitions to arp_tables.h
>   similar to ip_tables and ip6_tables
> 
> - use C99 initializers
> 
> - use initializer macros where possible
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
