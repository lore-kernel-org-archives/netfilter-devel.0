From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] libnetfitler_queue improvements
Date: Tue, 03 Jul 2007 13:25:48 +0200
Message-ID: <468A323C.8000509@trash.net>
References: <200707020038.l620caLv010450@toshiba.co.jp>	<4688F3B0.2080703@trash.net>
	<200707030146.l631kfVt014530@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Eric Leblond <eric@inl.fr>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707030146.l631kfVt014530@toshiba.co.jp>
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
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 02 Jul 2007 14:46:40 +0200
> 
> 
>>The queue handler unregistration stuff is really strange, so I'd rather
>>have it get some testing. I've applied both patches to 2.6.23, thanks.
> 
> 
> nfnetlink_log seems to have same issue, but I have not tested it yet.


You're right, I forgot about that.

>>>BTW, I think we'd better to do nothing for NFQNL_CFG_CMD_PF_[UN]BIND
>>>commands and to register queue handlers at init() automatically after
>>>removing ip[6]_queue.

>>> This might cause a misunderstanding. "removing ip[6]_queue" means
>>> that we remove ip[6]_queue.c from kernel source tree.


We already had it in feature-removal-schedule, but I removed it again
after realizing that we don't have a working compat library and even
if we did it wouldn't help since all applications are statically linked
against libipq. We could add it again, but we'd have to wait for at
least a year before we can really remove it IMO.


>>>
>>>Because they are diffcult to use. Even if we apply the first patch, a user
>>>process can unregister a queue handler registered by other process. And
>>>there is no way to count the number of process to use the handler (refcount
>>>per handler doesn't help because process can issue [un]binding command over
>>>again and again).
>>
>>
>>Its a horrible hack. Best thing would had been to make ip_queue and
>>nfnetlink_queue mutually exclusive from the beginning and provide
>>an actually working compat library.
> 
> 
> Exclusively loading is good idea and combination of it and my idea is
> perfect for me.


That would be fine I guess, they don't really work together anyway
so that would at least make it clear.

>>I guess what we could do now is to refcount the bindings and store
>>the bind state in the queue instance and allow each process to
>>unbind only the family it bound to. When processes close their
>>netlink socket their own bindings should also be released.
> 
> 
> We cannot do this because process can issue nfq_bind_pf() before creating
> queue (utils/nfqnl_test.c in libnetfilter_queue does this, for example).
> 
> nfq_bind_pf() of libnetfilter_queue takes the argument of netlink handle,
> not handle per queue. So it's ideal that kernel keeps refcount per socket,
> but we cannot do this because there is no structure to store it.


We could extend af_netlink so kernel sockets can specify some amount of
space they need to store per-socket state. But its questionable if thats
worth it just to get rid of this hack.

> I'm not sure really users of libnetfilter_queue want to use nfq_bind_pf().
> They can use different queue ID by NFQUEUE if they want their program to
> receive packets of specific address family. So I think it's better to handle
> nfq_bind_pf() as NOP.
> 
> But if anybody has scenario that it is useful to strict address family for
> queue, I agree to re-design nfq_bind_pf (will break API).


I'm only aware of what ulogd2 does, and that is using one queue ID per
family. I vaguely recall that NuFW supports IPv6 now .. maybe Eric can
give us some insight how it handles queue bindings.
