From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: BUG: libiptc chain references bug
Date: Thu, 13 Jul 2006 13:17:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0607131303220.29013@tyr.diku.dk>
References: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: hawk@comx.dk
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>
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


Hi

I have found the bug, and it's in libiptc.c.

More specifically in iptc_delete_entry() / TC_DELETE_ENTRY, 
and is a result of constructing "r" the rule entry that is used for 
comparison. The bug is that the function iptcc_map_target() increase the 
target chains references count...

I'll cook up a patch, once I have tested it.

This call sequence reveals the bug. I'm trying to delete a rule that does 
not exist, but during construction of "r" the match entry, the target 
chain "badehat" gets its reference count incremented.

[Function] init() libiptc handle
[Function] create_chain(badehat)
[Function] get_references(badehat): refs=0
[Function] iptables_do_command(-D FORWARD -j badehat): No chain/target/match by that name
[Function] iptables_do_command(-D FORWARD -j badehat): No chain/target/match by that name
[Function] iptables_do_command(-D FORWARD -j badehat): No chain/target/match by that name
[Function] iptables_do_command(-D FORWARD -j badehat): No chain/target/match by that name
[Function] get_references(badehat): refs=4
[Function] commit()

--
Best regards
   Jesper Brouer
   ComX Networks A/S
   Linux Network developer
   Cand. Scient Datalog / MSc.
   Author of http://adsl-optimizer.dk



On Wed, 12 Jul 2006, Jesper Dangaard Brouer wrote:

> I have found a chain reference bug in libiptc or iptables.c.
>
> When deleting a rule, with iptables do_command("-D xxx -j yyy") that
> calls "iptc_delete_entry" the reference count of the rules jump
> target chain is not decremented.
>
> When deleting the rule with iptables do_command("-D xxx rule_num")
> that calls "iptc_delete_num_entry" the reference count is correctly
> decremeted.
>
> Notice, that the chain gets the correct reference count after a
> "commit" of the handle.
>
>
> Here is the call sequence, of the bug:
>
> +------
> [Function] init() libiptc handle
> [Function] create_chain(badehat)
>
> [Function] iptables_do_command(-I FORWARD -j badehat)
> [Function] get_references(badehat): refs=1
>
> [Function] iptables_do_command(-D FORWARD -j badehat)
> [Function] get_references(badehat): refs=1
>
> [Function] commit()
>
> System command: iptables -L badehat
> Chain badehat (0 references)
> target     prot opt source               destination
> +------
>
> Here is the call sequence, where the bug does not occur:
>
> +------
> [Function] init() libiptc handle
> [Function] create_chain(badehat)
>
> [Function] iptables_do_command(-I FORWARD -j badehat)
> [Function] get_references(badehat): refs=1
>
> [Function] iptables_do_command(-D FORWARD 1)
> [Function] get_references(badehat): refs=0
>
> [Function] commit()
>
> System command: iptables -L badehat
> Chain badehat (0 references)
> target     prot opt source               destination
> +------
