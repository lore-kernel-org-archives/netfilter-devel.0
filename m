From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Linux 2.6.9-rc1
Date: Wed, 25 Aug 2004 23:35:05 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408252334230.28603@filer.marasystems.com>
References: <Pine.LNX.4.58.0408240031560.17766@ppc970.osdl.org>
	<412CDFEE.1010505@triplehelix.org>
	<20040825203206.GS5824@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040825203206.GS5824@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Aug 2004, Harald Welte wrote:

> The 'problem' is that we try to get a readlock while we're already
> protected under a write lock.
>
> Please see the following [quite trivial, but yet untested] patch:
>
> EXPORT_SYMBOL(ip_nat_used_tuple);
> +EXPORT_SYMBOL(ip_nat_find_helper);

Why this new exported symbol?

Regards
Henrik
