From: "David S. Miller" <davem@davemloft.net>
Subject: iptables as a state machine
Date: Thu, 30 Sep 2004 19:39:55 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040930193955.6fa24afc.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


So while waiting for a kernel build to finish I was sniffing
around the iptables code thinking about how one might optimize
the lookups.

The ipt targets are simple enough already, and I think this
shows the elegance of the core iptables design.

It's the main ip header + indev + outdev matching that is
the real memory and cpu cycle killer in these paths.  Once
we match the target, the verdict is determined quickly.

This made me think about how in the old days gcc's instruction
scheduler was computationally complex.  This was fixed by
representing the processor as a state machine, and this is how
the gcc insn scheduler works currently.  It's very fast and all
of the complexity is in building the state machine which is done
at gcc build time.

I think iptables core IP header + indev + outdev match is a
state machine problem as well.  Such a state machine can be
made extremely small memory wise.  The lookup can be something
like running a berkeley packet filter on the frame.  Except
that instead of a "yes or no" answer we get a pointer to a
target.

I think this would run as efficiently, if not more so, than the
various B-tree based schemes and it certainly would consume much
less memory.

The only trick is making the state machine building fast, and
where to put it (kernel or user space).

Comments?
