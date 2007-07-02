From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 0/2] libnetfitler_queue improvements
Date: Mon, 02 Jul 2007 09:38:35 +0900 (JST)
Message-ID: <200707020038.l620ca4E000915@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Hi Patrick,

These are for 2.6.23 tree. The first patch might be better to
go 2.6.22. Either one is fine with me.

BTW, I think we'd better to do nothing for NFQNL_CFG_CMD_PF_[UN]BIND
commands and to register queue handlers at init() automatically after
removing ip[6]_queue.

Because they are diffcult to use. Even if we apply the first patch, a user
process can unregister a queue handler registered by other process. And
there is no way to count the number of process to use the handler (refcount
per handler doesn't help because process can issue [un]binding command over
again and again).

-- Yasuyuki Kozakai
