From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 3/3] libnl: add netfilter log support
Date: Tue, 4 Sep 2007 18:48:48 +0200
Message-ID: <20070904164848.GU18480@postel.suug.ch>
References: <46DB9716.1020400@snapgear.com> <46DB97C0.3060602@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46DB97C0.3060602@snapgear.com>
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

* Philip Craig <philipc@snapgear.com> 2007-09-03 15:12
> 

> ---
>  include/linux/netfilter/nfnetlink_log.h |   96 +++++++
>  include/netlink-types.h                 |   22 +
>  include/netlink/netfilter/log.h         |  105 +++++++
>  lib/netfilter/log.c                     |  349 ++++++++++++++++++++++++++
>  lib/netfilter/log_obj.c                 |  425 ++++++++++++++++++++++++++++++++
>  src/nf-log.c                            |  142 ++++++++++
>  6 files changed, 1139 insertions(+)

Also applied, thanks for all this great work!
