From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 05:01:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F934FFD.7090700@trash.net>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>Agreed, partially.
>
>My opinions:
>
>It is imporant that userspace does not miss entries which was in the 
>kernel when duming started and still exists in the kernel when the dump 
>finished.
>
>It is also important userspace can have some kind of semi-static 
>reference to a conntrack to be able to manipulate that conntrack without 
>risking hitting another conntrack.
>
>It is OK for me if it is unspecified what happens with entries which 
>either was created or destroyed while the dump was in progress.
>

I totally agree.

>With these criterias in mind I propose a hybrid of your approaches
>
>a) Assign a globally unique ID to each conntrack, in such manner that IDs 
>is not reused for a significant amount of time. This to provide a stable 
>point of reference to a connection with low risk of false collisions if 
>the original connection was destroyed while userspace still thought it was 
>there. 
>
>b) When duming the conntrack entries, dump one bucket at a time. 
>If the bucket is too large to fit in the current response packet 
>then sort the bucket entries on ID and keep track of which bucket+ID 
>was last dumped. On next netlink packet restart at the same bucket and 
>skip the entries with a ID lower than those already dumped for that 
>bucket.
>
>This requires a read lock per hash bucket while dumping that bucket, and
>some small (usually) amount of memory to keep the temporary sorted index
>of bucket entries unless the bucket is permanently resorted in which case
>it may be possible to solve with no memory allocation (but then requires 
>the bucket to be write locked while resorting which is probably worse).
>

Sounds like a nice solution. I favour the permanent resorting for these 
reasons:
- all temporary memory allocations should be released before 
ctnetlink_dump is left,
  not in ctnetlink_done since we don't know if and when the read will 
continue. this means
  sorting multiple times is required.

- we can use some sorting algorithm which benefits from pre-sorted 
input. this would
  give better average performance. IIRC new conntracks are added at the 
head of the
  chains, so if we sort and walk backwards through the chains we only 
have to resort
  after an id counter wrap. Sorting is also pretty easy in that case: 
move all entries at
  head of list whose id is smaller than the last one's to the tail while 
preserving order,
  stop at first one thats bigger. This also means we only need the write 
lock in a very
  very rare case.

>Regarding the conntrack ID. For me it is acceptable if as much as 64 bits
>is reserved for the conntrack ID. This gives sufficient namespace to
>
>a) Provide truly unique IDs suitable for long-term reference without any 
>risk of collisions.
>

I agree, we should use 64 bit.

>b) Allows for the namespace to be built in such manner that there never
>will be any risk for congestion in finding the next available ID. For 
>example by using CPU#+counter.
>

Also a good idea. Thanks Henrik for your valuable input. Harald, what do 
you think of
this approach ?

Best regards,
Patrick (hoping mozilla will have mercy with his formatting this time)
