From: KOVACS Krisztian <hidden@balabit.hu>
Subject: TCP conntrack oddness
Date: Wed, 31 Mar 2004 09:50:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1080719401.1651.36.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

  Last week I had a problem with the current ("old") TCP connection
tracking code. My problem was that while the TCP stack said a connection
was in LAST_ACK state, the conntrack code said it was in TIME_WAIT.
(This wouldn't cause problems by itself, however, our own code relied on
this information. Apart from this the worst effect could be that instead
of a 30 s timeout we have 2 minutes by default.) Having a look at the
code, it turned out that in conntrack a connection _can't be_ in
LAST_ACK state.

  Although the TCP conntrack module's state machine has a LAST_ACK
state, that state is unreachable. In the transition graph the only edges
going to the sLA state are _from_ the sLA node.

  Of course I know the code is old, known to be oversimplified, and
Jozsef Kadlecsik's new code fixes the problem. However, I don't know
when his code will be merged, and I think the fact that an unreachable
state is present in the state machine code is definitely ugly (besides
causing problems).

-- 
 Regards,
   Krisztian KOVACS
