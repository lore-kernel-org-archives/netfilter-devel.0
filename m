From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 2.6.20 07/10] nfnetlink_log: fix module reference
	counting
Date: Tue, 13 Feb 2007 17:25:35 +0100
Message-ID: <20070213162535.GA10544@rere.qmqm.pl>
References: <20070212003956.GH8262@rere.qmqm.pl> <45D1B383.5060400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.org
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45D1B383.5060400@trash.net>
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

On Tue, Feb 13, 2007 at 01:48:03PM +0100, Patrick McHardy wrote:
> Micha³ Miros³aw wrote:
> > Count module references correctly: after instance_destroy() there
> > might be timer pending and holding a reference for this netlink instance.
> I think we should just cancel the timer on destruction.

It won't solve a race between destroying the instance and logging a
packet. It could happen that:

CPU1				CPU2
				nfulnl_log_packet()
				 -> instance_lookup_get()
				 -> lock inst
				 ** got lock on inst
_instance_destroy(inst)
 -> remove inst from list
 -> remove timer and unref inst
 -> lock inst
 				 -> start a timer
				 -> unlock inst
 ** got lock on inst
 -> clear the skb
 -> unlock inst
 -> unref inst
 -> unref module... but we still have a timer pending!

To solve that, we would need to wait until use count reached 1 somewhere
before instance_put() to be sure that no packet is being logged. That
would mean something like:

while (atomic_get(inst->use) > 1)
	del_timer_sync(&inst->timer);

I don't think it's worth the cpu cycles. The only problem I see is that
some user process could set up a long queue timeout and that would keep
the module from unloading until the timeout went off if the right packet
arrived in just the right moment. Do we need to care about this case?

BTW, in the nfnetlinkg_log.c version before my patches the timer is
cancelled already in __nfulnl_send().

 -- Michal Miroslaw
