From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: BUG: libiptc chain references bug
Date: Wed, 12 Jul 2006 17:25:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


I have found a chain reference bug in libiptc or iptables.c.

When deleting a rule, with iptables do_command("-D xxx -j yyy") that
calls "iptc_delete_entry" the reference count of the rules jump
target chain is not decremented.

When deleting the rule with iptables do_command("-D xxx rule_num")
that calls "iptc_delete_num_entry" the reference count is correctly
decremeted.

Notice, that the chain gets the correct reference count after a
"commit" of the handle.


  Here is the call sequence, of the bug:

+------
[Function] init() libiptc handle
[Function] create_chain(badehat)

[Function] iptables_do_command(-I FORWARD -j badehat)
[Function] get_references(badehat): refs=1

[Function] iptables_do_command(-D FORWARD -j badehat)
[Function] get_references(badehat): refs=1

[Function] commit()

System command: iptables -L badehat
Chain badehat (0 references)
target     prot opt source               destination
+------

  Here is the call sequence, where the bug does not occur:

+------
[Function] init() libiptc handle
[Function] create_chain(badehat)

[Function] iptables_do_command(-I FORWARD -j badehat)
[Function] get_references(badehat): refs=1

[Function] iptables_do_command(-D FORWARD 1)
[Function] get_references(badehat): refs=0

[Function] commit()

System command: iptables -L badehat
Chain badehat (0 references)
target     prot opt source               destination
+------


Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
