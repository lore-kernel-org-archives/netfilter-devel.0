From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 00/06]: Netfilter fixes for 2.6.17
Date: Wed, 03 May 2006 23:21:00 -0700 (PDT)
Message-ID: <20060503.232100.03285843.davem@davemloft.net>
References: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
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
Date: Tue,  2 May 2006 22:48:03 +0200 (MEST)

> following are my netfilter patches for 2.6.17, which fix a couple of bad bugs:
> 
> - The SCTP conntrack loop noticed by Ingo
> - The unchecked __copy_from/to in the compat code noticed by Linus
> - Two H.323 bugs found by the PROTOS c07-h2250v4 testsuite
> 
> I'll push the SCTP patch to -stable as well. There is still at least one open
> bug in the H.323 helper, but I can't really keep up with the pace new bugs are
> discovered at currently.
> 
> Please apply.

Thanks a lot for all of your great work killing off these
bugs.

All applied, excep the SCTP loop since Linus put it in already.

Thanks again!
