From: Thomas Heinz <creatix@hipac.org>
Subject: Loop Detection
Date: Sun, 15 Dec 2002 14:52:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DFC8933.9030607@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,  netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi

Michael Bellion and I are busy implementing user-defined chains support
for nf-hipac. When it comes to user-defined chains one has to
consider a way of detecting loops. Now, there are at least two
definitions of what a loop actually is. The netfilter one (Def1) and
and a "tighter" one (Def2).

Def1: The chains and their rules having another chain as target can
       be considered to define a directed graph. In this graph the
       chains are the nodes and for each chain X we have an edge
       (X, Y) if X contains a rule whose target is Y.
       Now, a loop exists if and only if the graph contains a cycle.

Example: Assume we have 3 chains: A, B, C. We only consider those
          rules within the chains that have another chain as target:
          A: Rule 1 -j B    B: Rule 2 -j A    C: Rule 4 -j B
             Rule 4 -j C
             Rule 5 -j C
             Rule 7 -j B
          The resulting graph is:
                     C
                   /\  \
                   /   \/
                  A <-> B
          This graph contains a cycle and therefore a loop according to
          Def1. If Rule 2 of Chain B is removed there is no loop.


The other definition which is tighter is:

Def2: If a packet is matched it traverses certain chains until a
       terminal target is reached. Those chains form a path.
       A loop exists if and only if there exists a packet whose path
       through the chains contains some chain at least twice.

Example: Assume we have 3 chains: INPUT, A, B.
          INPUT: (1) -s 1.0.0.0/16 -j A
                 (2) -s 2.0.0.0/16 -j B
          A:     (1) -s 1.0.0.0/24 -j B      B: (1) -s 2.0.0.0/24 -j A
                                                (2) -s 1.0.0.5 -j A
          Consider a packet with source ip 1.0.0.5 destined for the
          host running the firewall. The path is:
          INPUT, A, B, A, B, A, ...
          Clearly, there is a loop according to Def2. If rule (2) is
          removed from B there is no loop according to Def2 but there is
          still a loop according to Def1.

I hope the differences between the two definitions are clear. Obviously,
a loop according to Def2 always leads to a invalid ruleset but this is
not necessarily true for Def1.

Now, I'm asking you what definition is more beneficial to the users.
The question goes to both users and developers.

Clearly, a loop detection based on Def1 disallows some rulesets that are
indeed valid. On the other hand the question is whether such rulesets
really make sense. It is possible that Def1 is in fact more beneficial
to users in order to help them to design sane rulesets.

What is your opinion?


Regards,

Thomas
