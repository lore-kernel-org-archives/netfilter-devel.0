From: Tim Rhodes <rhodes@vt.edu>
Subject: ip_conntrack_in: Frag of proto 17
Date: Mon, 12 Jul 2004 11:30:31 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089646231.3157.23.camel@scratch.dynamic.vt.edu>
Reply-To: Tim.Rhodes@vt.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: NetFilter Development <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Is there any additional information/understanding of this condition. 
I've found some hits of 2.6.x kernels generating this message for
nfs/sfs.  I'm running a couple of systems (now running 2.6.7 kernel)
that run JBoss with replication.  These UDP connections are generating
these messages.  

One note referenced exceeding the block size that conntrack can handle.
Is there and if so, what's the limit.  The ip_conntrack_core.c code that
generates this message ANDs the frag offset with 8191.
-- 
.. Tim Rhodes  ........................................  Tim.Rhodes@vt.edu
.. NIS-Systems Support, Virginia Tech  ..  http://rhodes.cc.vt.edu/~rhodes
