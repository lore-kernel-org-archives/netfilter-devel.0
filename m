From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: ip_conntrack_lock usage?
Date: Sun, 08 Jun 2003 12:21:07 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306080221.h582L8f07562@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hey dudes,

  I finally have my dev machine back online, and a long weekend to look at
the RSH and RPC bugs, and the RPC enhancements.  However, I've gotten
myself bogged down in trying to understand usage of "ip_conntrack_lock"
READ/WRITE LOCKs.

  The old rpc-recent module(s) had a comment at the top that said;
    +/* For future conections RPC, using client's cache bindings
    + * I'll use ip_conntrack_lock to lock these lists         */

.. why would you use a global locking mechanism for lists that only have
local implications?

  The added confusion is that I can see no documentation on it in the HowTo's
or FAQ's .. and the only mentions in the Netfilter mailling archives are either
code references from the conntrack root code, or discussions on potential
performance bottlenecks.

  Should I be trying to implement a global locking structure in the RPC code,
or should I stick with what I've got?


Thanks,
 


--
Ian Latter
Internet and Networking Security Officer
Macquarie University
