From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PATCH 2.5.68] netfilter using Read Copy Update
Date: Thu, 24 Apr 2003 13:11:10 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030424131110.04726145.shemminger@osdl.org>
References: <20030424090406.504ada94.shemminger@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030424090406.504ada94.shemminger@osdl.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The motivation for this is to eventually get rid of all use's of brlock
in the 2.5 kernel.  The existing netfilter code uses the standard doubly
linked list structure so converting to RCU was not hard.

The only non-obvious change was introducing list_for_each_continue_rcu
which is just a way to move the loop used in nf_iterate up into the
include file where the other RCU list magic is held.

The netfilter hooks run in the same context as before (no preempt) and
have the same restrictions (can't sleep).
