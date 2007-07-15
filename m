From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 06/08]: x_tables: add connlimit match
Date: Sat, 14 Jul 2007 20:47:37 -0700 (PDT)
Message-ID: <20070714.204737.40833581.davem@davemloft.net>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
	<20070714151158.9829.19623.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151158.9829.19623.sendpatchset@localhost.localdomain>
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
Date: Sat, 14 Jul 2007 17:12:42 +0200 (MEST)

> [NETFILTER]: x_tables: add connlimit match
> 
> ipt_connlimit has been sitting in POM-NG for a long time.
> Here is a new shiny xt_connlimit with:
> 
>  * xtables'ified
>  * will request the layer3 module
>    (previously it hotdropped every packet when it was not loaded)
>  * fixed: there was a deadlock in case of an OOM condition
>  * support for any layer4 protocol (e.g. UDP/SCTP)
>  * using jhash, as suggested by Eric Dumazet
>  * ipv6 support
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, nice work guys.
