From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] libnetfitler_queue improvements
Date: Mon, 02 Jul 2007 14:46:40 +0200
Message-ID: <4688F3B0.2080703@trash.net>
References: <200707020038.l620caLv010450@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707020038.l620caLv010450@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi Patrick,
> 
> These are for 2.6.23 tree. The first patch might be better to
> go 2.6.22. Either one is fine with me.


The queue handler unregistration stuff is really strange, so I'd rather
have it get some testing. I've applied both patches to 2.6.23, thanks.

> BTW, I think we'd better to do nothing for NFQNL_CFG_CMD_PF_[UN]BIND
> commands and to register queue handlers at init() automatically after
> removing ip[6]_queue.
> 
> Because they are diffcult to use. Even if we apply the first patch, a user
> process can unregister a queue handler registered by other process. And
> there is no way to count the number of process to use the handler (refcount
> per handler doesn't help because process can issue [un]binding command over
> again and again).


Its a horrible hack. Best thing would had been to make ip_queue and
nfnetlink_queue mutually exclusive from the beginning and provide
an actually working compat library.

I guess what we could do now is to refcount the bindings and store
the bind state in the queue instance and allow each process to
unbind only the family it bound to. When processes close their
netlink socket their own bindings should also be released.
