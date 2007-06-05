From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 03/03]: nf_conntrack_amanda: fix
 textsearch_prepare() error check
Date: Tue, 05 Jun 2007 12:57:11 -0700 (PDT)
Message-ID: <20070605.125711.40574253.davem@davemloft.net>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
	<20070605133512.10309.32662.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605133512.10309.32662.sendpatchset@localhost.localdomain>
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
Date: Tue,  5 Jun 2007 15:35:12 +0200 (MEST)

> [NETFILTER]: nf_conntrack_amanda: fix textsearch_prepare() error check
> 
> The return value from textsearch_prepare() needs to be checked
> by IS_ERR(). Because it returns error code as a pointer.
> 
> Cc: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks a lot Patrick.
