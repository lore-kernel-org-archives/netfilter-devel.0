From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 16:12:37 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402291610550.26823-100000@filer.marasystems.com>
References: <20040229145945.GA23662@pcw.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20040229145945.GA23662@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 29 Feb 2004, Willy TARREAU wrote:

> ==> This patches fixes it :
> 
> --- ./conntrack_nonat/info.orig	Sun Feb 29 15:47:49 2004
> +++ ./conntrack_nonat/info	Sun Feb 29 15:47:19 2004
> @@ -1,4 +1,4 @@
>  Author: Jozsef Kadlecsik
>  Status: Testing
>  Repository: extra
> -Depends: conntrack_locking.patch
> +Depends: conntrack_locking

Also included in the jumbo patch sent yesterday..

Regards
Henrik
