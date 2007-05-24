From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 03/07]: nf_conntrack_h323: fix ASN.1 types
Date: Thu, 24 May 2007 16:42:37 -0700 (PDT)
Message-ID: <20070524.164237.40815199.davem@davemloft.net>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
	<20070524215837.14308.73241.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215837.14308.73241.sendpatchset@localhost.localdomain>
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
Date: Fri, 25 May 2007 00:02:10 +0200 (MEST)

> [NETFILTER]: nf_conntrack_h323: fix ASN.1 types
> 
> 1. Add support for decoding IPv6 address. I know it was manually added in
>    the header file, but not in the template file. That wouldn't work.
> 2. Add missing support for decoding T.120 address in OLCA.
> 3. Remove unnecessary decoding of Information signal.
> 
> Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
