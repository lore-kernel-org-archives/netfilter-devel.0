From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] NAT tuple reservation
Date: Tue, 18 Nov 2003 08:47:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FB9CE8E.4000105@balabit.hu>
References: <3FB8DF90.5090505@balabit.hu> <20031117222933.GE5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031117222933.GE5075@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
>>  The allocation routines in ip_nat_core.c should be extended to check if 
>>a tuple is reserved. ip_nat_used_tuple() would be extended to check if the 
>>given tuple uses an already reserved manip. The reserved manips would be 
>>stored in a hash table, hashed based on the manip structure. The stored 
>>structures would look something like this:
> 
> 
> However, I fear this would add considerable overhead.  Yet another hash
> table... however, most of the time this table would be empty, or almost
> empty.  So let's rather optimize on the speed of the hash function than
> on the hash distribution in that case.

   The empty case could be made fast using a reservation-counter.

>>struct ip_nat_reserved {
>>  /* hash chain */
>>  list_head prev, next;
> 
> you only need one list head for the hash table ;)

   Of course... :)

>>  /* reference count */
>>  atomic_t use;
> 
> do we really need to do sophisticated reference counting on those
> objects?  I think it is enough to protect the whole hash table under the
> already existing nat lock.  Entries are inserted/deleted under that lock, and
> hash table lookups also only happen under that lock.   The only
> reference would be a pointer from a single ip_conntrack_expect - thus
> the refcount would always be one.
> 
> 
>>ip_nat_setup_info_reserved(...): This is basically the same as 
>>ip_nat_setup_info, except that it calls ip_nat_setup_info() with the 
>>appropriate flag, and deletes the reservation in case of successful 
>>allocation.
>>
>>  Do you see any shortcomings/problems with this?
> 
> 
> It doesn't cover allocation/reservation of contiguous port numbers,
> which especially RTP/RTSP require. 

   It could be extended, however, it would make checking/allocating even 
more slow... If you could register ranges, for example, how do you define 
the hash function? Or, for example, you should be able to delete parts of 
that range from the reserved list, so that splitting the original range 
could be necessary... Cannot problems like these solved by allowing more 
than one reservation per expectation to be registered?

-- 
   Regards,
     Krisztian KOVACS
