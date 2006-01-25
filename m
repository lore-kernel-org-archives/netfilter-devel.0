From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER] nf_conntrack: fix memset() size.
Date: Wed, 25 Jan 2006 13:05:18 +0900 (JST)
Message-ID: <200601250405.k0P45IjD000878@toshiba.co.jp>
References: <m2hd7tass3.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: sbellabes@mandriva.com
In-Reply-To: <m2hd7tass3.fsf@cerbere.dyndns.info>
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


Hi,

From: Samir Bellabes <sbellabes@mandriva.com>
Date: Wed, 25 Jan 2006 04:30:20 +0100

> This patch fix a bad size in memset().
> The memory handle by 'struct nf_conntrack_helper ftp[MAX_PORTS][2]' is
> only set for ftp[*][0], but not for ftp[*][1].
> 
> please apply, thanks
> sam

Thanks. But I think better change is just removing this memset()
because 'ftp' is declared in global area. Can I ask you to re-send a patch
which just removes this memset() ?

-- Yasuyuki Kozakai
