From: "Jim Gifford" <maillist@jg555.com>
Subject: Re: Bug-Report 3-19-03 patch-o-matic-ng
Date: Fri, 2 Apr 2004 11:52:59 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <030901c418ec$19f3c0d0$d100a8c0@W2RZ8L4S02>
References: <Pine.LNX.4.33.0403221004140.24116-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Update on the problem, it occurs more then the example I gave in the
original email(original problem included)

The problem is that patch-o-matic is not check the Already applied line
before attempting to patch.

Here is the newer version of the problem
First of all let me walk you through the steps I used to create this
problem.

I apply the nf-log patch. It applies correctly.
I apply the TRACE patch. It bombs with the error apply_dependencies: unable
to apply dependent nf-log: cannot apply (22 rejects out of 24 hunks)

Here is a complete screen of the error.

Welcome to Patch-o-matic (1.15)!

Kernel:         /usr/src/linux
Iptables:       /usr/src/iptables

Each patch is a new feature: many have minimal impact, some do not.
Almost every one has bugs, so don't apply what you don't need!
-------------------------------------------------------
Already applied: init_conntrack-optimize ipt_helper-invert-fix nf-log
proc-no-internal-targets NETMAP SAME TTL connlimit fuzzy iprange nth sctp
CLASSIFY IPMARK

Testing TRACE... not applied
The TRACE patch:
   Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
   Status: Testing.


   This patch adds the TRACE target to the raw table.

   The TRACE target can be used to trace how the packet "flows trough"
   your tables and rules. When a packet marked with the TRACE target
   matches any rule, the system logs the packet with the following
   prefix:

        TRACE: tablename/chainname/rulenum packet

   BEWARE: if you apply this patch, you loose backward compatibility
   with your current iptables binary, so you *must* recompile
   the userspace program as well.

-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
apply_dependencies: unable to apply dependent nf-log: cannot apply (22
rejects out of 24 hunks)
-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?]


The original problem was

 Welcome to Patch-o-matic (1.15)!

 Kernel:         /usr/src/linux
 Iptables:       /usr/src/iptables

 Each patch is a new feature: many have minimal impact, some do not.
 Almost every one has bugs, so don't apply what you don't need!
 -------------------------------------------------------
 Already applied: init_conntrack-optimize ipt_helper-invert-fix nf-log
NETMAP
 SAME TTL connlimit fuzzy iprange mport nth sctp CLASSIFY
 iptables-loopcheck-speedup netfilter-docbook

 Testing tcp-window-tracking... not applied
 The tcp-window-tracking patch:
    Author: Jozsef Kadlecsik
   Status: proven to be quite stable, but still experimental

 Now for the error message
 -----------------------------------------------------------------
 Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
 present 'ctstat' conflicts with to-be-installed 'tcp-window-tracking'
 -----------------------------------------------------------------
 Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
 apply_dependencies: unable to apply dependent nf-log: cannot apply (22
 rejects out of 24 hunks)
 -----------------------------------------------------------------

As you notice ctstat is not installed and nf-log is installed.
