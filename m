From: Henrik Nordstrom <hno@marasystems.com>
Subject: [BUG] Netfilter ipt_owner deadlock (fwd)
Date: Sun, 16 May 2004 14:06:52 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405161406060.30410-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Found on linux-net

---------- Forwarded message ----------
Date: Fri, 14 May 2004 17:19:05 +0200
From: Christophe Saout <christophe@saout.de>
To: linux-net@vger.kernel.org
Subject: [BUG] Netfilter ipt_owner deadlock

Hi,

there's a nasty problem with the ipt_owner netfilter code:

It does a spin_lock(&files->file_lock), sometimes from softirq context.
This can lead to deadlocks on SMP systems. The lock must not be taken
from softirq context because the rest of the kernel doesn't use
spin_lock_bh.

On a UP machine (that had an SMP compiled kernel) the machine repeatedly
locked up after approx. five minutes. SysRQ shows backtraces like fput
-> timer interrupt -> softirq -> ipv4 -> netfilter -> ipt_owner -> hang.

I don't see a clean solution for this (except for changing all the
spin_locks to spin_lock_bhs which I think is way too aggressive).

Any ideas?


