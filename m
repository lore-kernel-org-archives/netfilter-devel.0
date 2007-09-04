From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Tue, 4 Sep 2007 13:36:37 +0200
Message-ID: <20070904113637.GR18480@postel.suug.ch>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46DB9776.8020209@snapgear.com>
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

* Philip Craig <philipc@snapgear.com> 2007-09-03 15:11
> 

> ---
>  include/linux/netfilter/nfnetlink.h |  106 +++++++++++++++
>  include/netlink/netfilter/nfnl.h    |   44 ++++++
>  include/netlink/netlink.h           |    1 
>  lib/Makefile                        |    2 
>  lib/attr.c                          |    3 
>  lib/netfilter/nfnl.c                |  246 ++++++++++++++++++++++++++++++++++++
>  6 files changed, 401 insertions(+), 1 deletion(-)

I've applied this patch with some minor modification which is the
removal of most of the macros from include/linux/netfilter/nfnetlink.h
for the purpose of making sure people use the generic alternatives.

Thanks a lot Philip!
