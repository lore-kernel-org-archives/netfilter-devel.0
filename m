From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 00:55:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F931647.5060204@trash.net>
References: <20031019171851.GR21521@sunbeam.de.gnumonks.org> <3F92E7CD.3010607@trash.net> <20031019202814.GU21521@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031019202814.GU21521@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>>The ordered list and the unique conntrack id was added for table 
>>dumping. Without it entries could be dumped multiple times or even
>>worse a single hash chain chould be dumped over and over again if it's
>>contents exceeded the size of a single skb.
>>    
>>
>
>ah, yes.  I remember.  but that actually is a shortcoming of the netlink
>api, isn't it?  The problem is that we cannot save an exact position in
>the hashtable where we stopped dumping.   So in my original ctnetlink we
>just dump a whole bucket and saved the bucket number in cb->args[].  But
>if we were saving bucket number + number of connection in bucket, we
>could continue where we left from.  
>
>Of course, entries could be added before that number (or even in buckets
>that we had already traversed) - but we don't guarantee an atomic
>snapshot anyway.
>
In my opinion for any serious use we need to provide a mechanism for 
userspace to be sure
it is in sync with the kernel. We could just add a new message type 
which contains the total
number of entries. That way userspace could check the number, if unequal 
to number of
connections known in userspace dump table, repeat. Of course this is 
still racy but it would
be better than nothing.

There was a thread on linux-net recently (subject: xfrm_user 
reliability) which is related to
this. Alexey mentioned reliable transmissions from kernel to userspace 
are impossible, so
userspace needs a recovery mechanism from dropped event messages (dump 
table and
resync). If dump table is also unreliable and doesn't even signal 
failure userspace is screwed.
Nice thing with the unique ids is that it's better than an atomic 
snapshot, when you're done
reading you have the _current_ state, not the state when you began reading.

>Also, there's another problem:
>Let's say we left at bucket 5, entry 12 - and while we are waiting for
>the next netlink callback, entry 10 gets removed.  Then we would
>continue at 12, which is in reality the old 13.  So we're missing one
>conntrack.  
>

With the unique id solution ? No, the id's don't represent the 
list-position, what happens is
that every conntrack with an id less or equal to the last one dumped is 
skipped. Since they
are ordered by increasing id we will still continue at entry 13, only 
that it now has position
12 on the list.

>The question is what to do.  I really don't like having yet another list
>of conntracks (the ordered list) together with the unique id.  It is
>questionable how big the impact on performance is (contention on unique
>ID, bigger struct ip_conntrack, additional list_add's), but even if it
>was 'cheap', I don't like the architecture.
>

I didn't worry too much about performance yet, in my opinion it was 
required for beeing
useful. For the architecture, if it was only for table dumping I'd agree 
with you, but there is
another important use for the id. When we want to manipulate/delete 
conntrack entries from
userspace there is no way to make sure that we will do things the the 
right connection since
the tuples that are used for lookup could have been reused. This is 
especially true a tuple is
used for lookup that has been changed by nat.

>Other approaches I can think of:
>
>a) making a snapshot of the whole conntrack table.
>Large memory usage - probably easy to get OOM :(  Also, read lock on
>ip_conntrack_lock would have to be grabbed long
>
>b) unique ID per hash bucket.  This means less contention, but we could
>only save bucket id in cb->args, start iterating from the beginning and
>only send whose ID is newer than the last one we already sent.
>
>c) snapshot of the current bucket
>As with the new hash function every bucket is supposed to be short, we
>could also make a snapshot of the current bucket, and send our messages
>from this snapshot copy.
>
>what do you think?
>

I think we first need to agree on how important the problems I mentioned 
above are. All
these solutions don't provide reliable mechanisms. Some comments though:

a) problem is that there can be multiple parallel dumps so we 
potentially need many copies.
I think memory usage is not acceptable.

b) I'm not sure if i understand correctly, this is basically what has 
been done before my
changes except that we would always continue at the next bucket id and 
not just advance
if the whole bucket has successfully dumped ?

c) same problem as a, except memory usage is not as bad. IMO it is a 
basically a workaround
for limited socket buffers to circumvent the limits. If we don't need 
reliability I'd say it's the users
job to make sure socket buffer limits are set to a reasonable size.

So in conclusion if we agree we need reliability, we probably need the 
unique ids. If we agree
we don't, I'd say we use solution b.

>As you may have noticed, I already did that with 0.13 in current cvs.
>
Yes, Krisztian pointed me to the code.

Two last things I noted during writing the mail:
- Table dumping is currenlty not restricted to root, this should 
probably be done for privacy reasons.
- Have you got objections against s/CTA_RPLY/CTA_REPLY/ ? IMO It makes 
typing and thinking
more comfortable if you can actually pronounce what you are thinking 
about ;)

Best regards,
Patrick
