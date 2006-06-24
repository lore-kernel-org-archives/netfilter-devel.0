From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [PATCH] libiptc.c blob parser
Date: Sat, 24 Jun 2006 14:06:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0606241355030.24513@ask.diku.dk>
References: <FFEPKIHJDEDDAAFOFDGFCELECBAA.PCDiem@FoxValley.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Paul C. Diem" <PCDiem@FoxValley.net>
In-Reply-To: <FFEPKIHJDEDDAAFOFDGFCELECBAA.PCDiem@FoxValley.net>
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

Hi Paul

To confirm, I have notized the same issus.  I wrote to Harald but he has 
not responded yet. So, I guess I'll follow up on this one... Nice to hear 
the you have solved the issue.

First of all, could you please produce a proper patch!? (diff -Nurp)
So that we can see whats going on...

Here is my post to Harald:
-------
Sent:  	 Mon 6/19/2006 16:14
Subject: Performance work on libiptc

Hi Harald

I hope you can help me out.  I have a performance issue with iptables
which I have tracked down to the libiptc parsing.

I would like to solve it, but need some help with the data structures.

  There is a scalability/performance issue in libiptc.c, when parsing
  the ruleset blob.  The problem lies in the "Second pass" (of func
  parse_table) where the userchain jump targets are fixed/corrected.

  The "Second pass" loop has a bad worstcase run time of O(C*R).

  For each rule "R" with a IPTCC_R_JUMP target, func
  iptcc_find_chain_by_offset searches through the chain list "C"
  (worstcase hitting the last one).

  In my real life production system I have R=4492 and C=2238, giving a
  worstcase loop of 10.053.096.

Basically, we need to make "iptcc_find_chain_by_offset" smarter... do you 
have any proposals?
------

I simply tracked down the problem using gprof.

gprof output:
+-----
Each sample counts as 0.000999001 seconds.
   %   cumulative   self              self     total
  time   seconds   seconds    calls  ms/call  ms/call  name
  77.99      0.20     0.20     4492     0.04     0.04  iptcc_find_chain_by_offset
  20.46      0.25     0.05     2238     0.02     0.02  iptc_insert_chain
   1.16      0.26     0.00    16218     0.00     0.00  cache_add_entry
   0.39      0.26     0.00        1     1.00   258.74  parse_table
   0.00      0.26     0.00    13982     0.00     0.00  iptcc_alloc_rule
   0.00      0.26     0.00     2239     0.00     0.00  __iptcc_p_del_policy
   0.00      0.26     0.00     2238     0.00     0.02  __iptcc_p_add_chain
   0.00      0.26     0.00     2238     0.00     0.00  iptcc_alloc_chain_head
   0.00      0.26     0.00     2238     0.00     0.00  iptcc_delete_rule
   0.00      0.26     0.00        1     0.00     0.00  add_command
   0.00      0.26     0.00        1     0.00     0.00  alloc_handle
   0.00      0.26     0.00        1     0.00     0.00  clear_rule_matches
   0.00      0.26     0.00        1     0.00   258.74  do_command
   0.00      0.26     0.00        1     0.00     0.00  find_target
   0.00      0.26     0.00        1     0.00     0.00  free_opts
   0.00      0.26     0.00        1     0.00     0.00  generic_opt_check
   0.00      0.26     0.00        1     0.00     0.00  iptc_create_chain
   0.00      0.26     0.00        1     0.00   258.74  iptc_init
   0.00      0.26     0.00        1     0.00     0.00  iptc_strerror
   0.00      0.26     0.00        1     0.00     0.00  iptcc_find_label
+-----

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------


On Fri, 23 Jun 2006, Paul C. Diem wrote:

> We have about 30,000 mangle table rules in about 8,000 chains. iptc_init
> takes about 10 seconds just to load and parse the table. The problem is the
> second parse phase that iterates through every chain and every rule
> searching for the offset of the target for every jump rule.
>
> I've applied the following small patch that loads the offset of the chain
> entry into the comefrom field of the first rule ipt entry in each
> user-defined chain in the first pass. This comefrom field is then used in
> the second pass to easily locate the target chain. This minor change has
> reduced the load time of our mangle table to 1 second.
>
> Paul C. Diem
> PCDiem@FoxValley.net
>
> 309a310,314
>> /*+PCD
>> * Modification to use the offset to the chain entry in the ipt
>> * entry comefrom field as loaded by iptcc_find_chain_by_offset.
>> */
>> #if 0
> 319a325,329
>> #else
>> 	STRUCT_ENTRY * e = ((STRUCT_ENTRY *)((char *)handle->entries->entrytable
> + offset));
>> 	return (struct chain_head *)((char *)e + e->comefrom);
>> #endif
>> /*-PCD*/
> 496a507,512
>> /*+PCD
>> * Load the offset to the chain entry relative to the
>> * ipt entry into the ipt entry comefrom field.
>> */
>> 		e->comefrom = (char *)h->chains.prev - (char *)e;
>> /*-PCD*/
>
>
