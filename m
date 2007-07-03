From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/2] libnetfitler_queue improvements
Date: Tue, 03 Jul 2007 10:56:06 +0900 (JST)
Message-ID: <200707030156.l631u7Rp004527@toshiba.co.jp>
References: <200707020038.l620caLv010450@toshiba.co.jp>
	<4688F3B0.2080703@trash.net>
	<200707030146.l631kfvX011265@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707030146.l631kfvX011265@toshiba.co.jp>
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


From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Tue, 03 Jul 2007 10:46:40 +0900 (JST)

> > > BTW, I think we'd better to do nothing for NFQNL_CFG_CMD_PF_[UN]BIND
> > > commands and to register queue handlers at init() automatically after
> > > removing ip[6]_queue.

This might cause a misunderstanding. "removing ip[6]_queue" means that we
remove ip[6]_queue.c from kernel source tree.

-- Yasuyuki Kozakai
