From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 03:05:41 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
References: <3F931647.5060204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F931647.5060204@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 20 Oct 2003, Patrick McHardy wrote:

> In my opinion for any serious use we need to provide a mechanism for
> userspace to be sure it is in sync with the kernel. We could just add a
> new message type which contains the total number of entries. That way
> userspace could check the number, if unequal to number of connections
> known in userspace dump table, repeat. Of course this is still racy but
> it would be better than nothing.

Agreed, partially.

My opinions:

It is imporant that userspace does not miss entries which was in the 
kernel when duming started and still exists in the kernel when the dump 
finished.

It is also important userspace can have some kind of semi-static 
reference to a conntrack to be able to manipulate that conntrack without 
risking hitting another conntrack.

It is OK for me if it is unspecified what happens with entries which 
either was created or destroyed while the dump was in progress.


With these criterias in mind I propose a hybrid of your approaches

a) Assign a globally unique ID to each conntrack, in such manner that IDs 
is not reused for a significant amount of time. This to provide a stable 
point of reference to a connection with low risk of false collisions if 
the original connection was destroyed while userspace still thought it was 
there. 

b) When duming the conntrack entries, dump one bucket at a time. 
If the bucket is too large to fit in the current response packet 
then sort the bucket entries on ID and keep track of which bucket+ID 
was last dumped. On next netlink packet restart at the same bucket and 
skip the entries with a ID lower than those already dumped for that 
bucket.

This requires a read lock per hash bucket while dumping that bucket, and
some small (usually) amount of memory to keep the temporary sorted index
of bucket entries unless the bucket is permanently resorted in which case
it may be possible to solve with no memory allocation (but then requires 
the bucket to be write locked while resorting which is probably worse).


Regarding the conntrack ID. For me it is acceptable if as much as 64 bits
is reserved for the conntrack ID. This gives sufficient namespace to

a) Provide truly unique IDs suitable for long-term reference without any 
risk of collisions.

b) Allows for the namespace to be built in such manner that there never
will be any risk for congestion in finding the next available ID. For 
example by using CPU#+counter.

Regards
Henrik
