From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 2/3] libnl: add netfilter conntrack support
Date: Tue, 4 Sep 2007 18:45:48 +0200
Message-ID: <20070904164548.GT18480@postel.suug.ch>
References: <46DB9716.1020400@snapgear.com> <46DB979A.2010501@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46DB979A.2010501@snapgear.com>
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
>  include/linux/netfilter/nfnetlink_conntrack.h |  140 +++++
>  include/netlink-types.h                       |   44 +
>  include/netlink/addr.h                        |    1 
>  include/netlink/netfilter/ct.h                |  115 ++++
>  include/netlink/utils.h                       |    4 
>  lib/addr.c                                    |   28 +
>  lib/netfilter/ct.c                            |  422 ++++++++++++++++
>  lib/netfilter/ct_obj.c                        |  667 ++++++++++++++++++++++++++
>  lib/utils.c                                   |   36 +
>  src/Makefile                                  |    6 
>  src/f_ct.c                                    |  153 +++++
>  src/nf-ct-dump.c                              |   88 +++
>  src/nf-monitor.c                              |  115 ++++
>  13 files changed, 1818 insertions(+), 1 deletion(-)

Patch applied, thanks!
