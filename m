From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: REDIRECT
Date: Mon, 13 Dec 2004 11:23:11 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412131122300.10488@filer.marasystems.com>
References: <899467342.20041213130514@server.titansoft.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: r00t <root@server.titansoft.ru>
In-Reply-To: <899467342.20041213130514@server.titansoft.ru>
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

On Mon, 13 Dec 2004, r00t wrote:

> How to i make by libipq  this rule:
>
> -j REDIRECT --to-ports 3128 ?

You don't.

REDIRECT or other NAT related operations must be done in the kernel.

Regards
Henrik
