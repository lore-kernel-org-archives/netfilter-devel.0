From: Giacomo Strangolino <delleceste@gmail.com>
Subject: help linked lists and locks
Date: Wed, 23 Nov 2005 12:10:39 +0100
Message-ID: <43844E2F.5090809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Good morning.
In a packet filter which i wrote on my own, i have a linked list of 
structures
which i read periodically by means of list_for_each_safe macro.
These structures have a timer, when it expires, the entry is deleted.
The timer can on the other way be updated by mod_timer.

The context of execution is that of a software interrupt (i attach my 
code at
netfilter hooks), and some times (after tenths of millions of packets 
filtered)
the system goes into panic.

I think i should put some locks when reading in list_for_each or when
deleting an item, or when updating timers.

I thought it was not necessary because of the atomic context.

In fact, should i use read/write_lock? Or spinlocks?

Should i put the locks when reading in list_for_each, when adding an entry
with list_add, when deleting with list_del and also when mod_timer?

I verified that when i put those locks, things go better, but do i need them
so many in my code?

Thanks in advance

Giacomo.
