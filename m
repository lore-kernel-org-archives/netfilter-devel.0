From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] fix correct_cache() in libiptc.c
Date: 05 Jul 2003 15:19:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1057411145.12437.128.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

I got a report on irc that iptables -X didn't work like it used to.
Seems related to your libiptc work... you touched it last, you get to
check all new patches against it :)


Test-cases:
filter table is empty.

# ./iptables -N HELLO
# ./iptables -N world
# ./iptables -X
#

Nothing wrong here.


Just switching the order of chains...

# ./iptables -N world
# ./iptables -N HELLO
# ./iptables -X
iptables: No chain/target/match by that name
#

Huh?

The cause of this is that chains aren't removed in the order they were
created, they are removed in sorted order and the code for deletion of a
chain is currently somewhat busted.

Now I've added

printf("Deleting chain: %s\n", cc->name);

in libiptc/libiptc.c:481


Lets go back to the first testcase which seemed to work.

# ./iptables -N HELLO
# ./iptables -N world
# ./iptables -X
Deleting chain: FORWARD
Deleting chain: OUTPUT
Deleting chain: HELLO
#

That's not right.

Let's see what it does in the testcase that really failed...

# ./iptables -N world
# ./iptables -N HELLO
# ./iptables -X
Deleting chain: world
iptables: No chain/target/match by that name
#

Ok this is weird.

If you add more printf's you see that TC_DELETE_CHAIN() gets called for
the HELLO chain and find_label() finds it and then delete_rules() is
called. delete_rules() calls correct_cache() which thinks it should
delete the chain called world instead.
And then TC_DELETE_CHAIN() is called for the world chain and now
cache_num_chains has been decremented by one so it doesn't find the
world chain which is last.

I've found two errors in the code, patch below.

--- userspace/libiptc/libiptc.c.orig	2003-06-28 18:30:40.000000000 +0200
+++ userspace/libiptc/libiptc.c	2003-07-04 22:15:54.000000000 +0200
@@ -471,15 +471,15 @@
 
 		if (delta < 0) {
 			/* take care about deleted chains */
-			if (cc->start_off >= offset+delta
-			    && cc->end_off <= offset) {
+			if (cc->start_off > offset
+			    && cc->end_off < offset-delta) {
 				/* this chain is within the deleted range,
 				 * let's remove it from the cache */
 				void *start;
 				unsigned int size;
 
 				h->cache_num_chains--;
-				if (i+1 >= h->cache_num_chains)
+				if (i == h->cache_num_chains)
 					continue;
 				start = &h->cache_chain_heads[i+1];
 				size = (h->cache_num_chains-i)



With this patch it becomes:

# ./iptables -N HELLO
# ./iptables -N world
# ./iptables -X
Deleting chain: HELLO
Deleting chain: world
#

Much better.


# ./iptables -N world
# ./iptables -N HELLO
# ./iptables -X
Deleting chain: HELLO
Deleting chain: world
#

Ahh. Both cases work like they should.

Now it selects the correct chain to delete.
And the off-by-one bug causes it to do nothing when it comes to the
second-last chain which is wrong, it should do the memory-copies for all
deleted chains except when it's the last chain that's beeing deleted.

I'm not sure if my new limits in the first if-statement are 100%
correct. I don't know the code that well, and honestly I never want to,
I got enough exposure for several lifetimes last night. The code is
absolutely horrible...

Oh yes, this fix actually makes iptables-restore work again...

filter table is once again empty:
Without patch:

# ./iptables -A INPUT
# ./iptables -A FORWARD
# ./iptables -A OUTPUT
# ./iptables-save > file
# ./iptables-restore < file
Deleting chain: INPUT
Deleting chain: FORWARD
iptables-restore: line 13 failed
#

With the patch above it works fine. And it only deletes user-defined
chains that exist before iptables-restore is run. (which is none in this
simple testcase)


I have one more thing I want you to look at, once again in
correct_cache()...

                if (cc->start_off > offset)
                        cc->start_off += delta;

                if (cc->end_off >= offset)
                        cc->end_off += delta;

Shouldn't that really be moved up into the part where chains are deleted
and turned into an unconditional loop that adds delta (which is
negative) for all moved chains? What if several chains are deleted at
once? Currently that isn't done but correct_cache() implies that it
supports it because it doesn't stop looking for deleted chains after the
first one is found.

-- 
/Martin
