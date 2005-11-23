From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: locking while reading linked lists.
Date: Wed, 23 Nov 2005 07:51:36 -0800
Message-ID: <20051123075136.6036713f@localhost.localdomain>
References: <885896af0511230016r3eb7b0b7j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
In-Reply-To: <885896af0511230016r3eb7b0b7j@mail.gmail.com>
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

On Wed, 23 Nov 2005 09:16:46 +0100
Giacomo <delleceste@gmail.com> wrote:

> Good morning.
> In a packet filter which i wrote on my own, i have a linked list of structures
> which i read periodically by means of list_for_each_safe macro.
> These structures have a timer, when it expires, the entry is deleted.
> The timer can on the other way be updated by mod_timer.
> 
> The context of execution is that of a software interrupt (i attach my code at
> netfilter hooks), and some times (after tenths of millions of packets filtered)
> the system goes into panic.
> 
> I think i should put some locks when reading in list_for_each or when
> deleting an item, or when updating timers.
> 
> I thought it was not necessary because of the atomic context.
> 
> In fact, should i use read/write_lock? Or spinlocks?

Learn how to use RCU. There is lots of info in Documentation/RCU/
and there are list macro's that make it painless.
