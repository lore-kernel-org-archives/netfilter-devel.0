From: Olaf Rempel <razzor@kopf-tisch.de>
Subject: flushing conntrack-table
Date: Sat, 12 Mar 2005 00:34:18 +0100
Message-ID: <20050312003418.6a582ad9@coruscant>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Hi list

I've build a modul to flush some/all conntracks from the ct-table, but have 
some questions about the used functions and locking issues.

I'm sending a "search pattern" (proto + srcip/mask + sport-range + dstip/mask 
+ dport-range) via ioctl (yeah, i know..) to the kernel, and delete all matching
conntracks. 

As far as I understand, I don't need hold a lock while iterating over the 
hash-buckets, only when accessing the list inside.

To actually delete a conntrack (via del_timer + ct->timeout.function) the code 
must NOT hold the readlock, because death_by_timeout() grabs the writelock. 
Correct?

idea 1:
if a matching tuple is found, abort the search, delete conntrack and restart 
search in same bucket (assuming that there could be another matching tuple):

while (bucket < ip_conntrack_htable_size) {
	struct ip_conntrack *ct = NULL;

	READ_LOCK(&ip_conntrack_lock);
	list_for_each_entry(hash_tuple, &ip_conntrack_hash[bucket], list) {
		if (match_pattern(hash_tuple, pattern)) {
			ct = tuplehash_to_ctrack(hash_tuple);
			break;
		}
	}
	READ_UNLOCK(&ip_conntrack_lock);

	if (ct) {
		if (del_timer(&ct->timeout))
			ct->timeout.function((unsigned long)ct);

	} else {
		bucket++;
	}
}

idea 2:
same as idea 1, but storing N matching conntracks in an array. if the array is 
full, or the search in this bucket is complete then delete the found conntracks.
if array was full, restart search in same bucket else do next bucket.
N is small (~4), just to avoid search-restart in the same bucket with 2-3 matching
tuples. (don't know if it's needed)

idea 3:
use list_for_each_entry_safe(), when a matching tuple is found, 
release the readlock, delete the conntrack, grab readlock, resume search:

	READ_LOCK(&ip_conntrack_lock);
	list_for_each_entry_safe(hash_tuple, tmp, &ip_conntrack_hash[bucket], list) {
		if (match_pattern(hash_tuple, pattern)) {
			ct = tuplehash_to_ctrack(hash_tuple);
			READ_UNLOCK(&ip_conntrack_lock);

			if (del_timer(&ct->timeout))
				ct->timeout.function((unsigned long)ct);

			READ_LOCK(&ip_conntrack_lock);
		}
	}
	READ_UNLOCK(&ip_conntrack_lock);

I know I could do this with ctnetlink or something equal, but I want to try this
in kernel. The code from idea #2 works for me, but I just want to know if it's
a good way.

So, which of these ideas is "the best"?
Or am I missing something (== my code is crap :)

Olaf
