From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] NAT tuple reservation
Date: Wed, 19 Nov 2003 11:21:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBB4422.6070102@balabit.hu>
References: <3FB8DF90.5090505@balabit.hu> <20031117222933.GE5075@sunbeam.de.gnumonks.org> <3FB9CE8E.4000105@balabit.hu> <20031118165734.GP5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031118165734.GP5075@sunbeam.de.gnumonks.org>
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
>>>>/* reference count */
>>>>atomic_t use;
>>>
>>>do we really need to do sophisticated reference counting on those
>>>objects?  I think it is enough to protect the whole hash table under the
>>>already existing nat lock.  Entries are inserted/deleted under that lock, 
>>>and
>>>hash table lookups also only happen under that lock.   The only
>>>reference would be a pointer from a single ip_conntrack_expect - thus
>>>the refcount would always be one.
> 
> you didn't comment on that.  What do you think?

   I think we should try it this way. Currently I don't see anything which 
would require reference counting. However, we have to be sure that 
referenced reservations do not get deleted without setting the pointer to 
NULL. As the proposed interface allocates reservations only for 
expectations, the pointer can be easily handled there. So, the only 
remaining issue is that proper locking and checking should be implemented 
in the register/unregister functions. I don't know if we would need an 
additional lock for that, I suspect that ip_nat_lock will be enough.

> I don't care about allocation speed, as it is a rare thing to happen
> (compared to the total number of packets we see).  However, checking
> should be fast.

   The proposed implementation would require a hash table lookup only if 
there is at least one reservation. For the hash function, hash_by_src() 
could be used, which is rather simple:

   return (manip->ip + manip->u.all + proto) % ip_nat_htable_size;

>>If you could register ranges, for example, how do you define 
>>the hash function? Or, for example, you should be able to delete parts of 
>>that range from the reserved list, so that splitting the original range 
>>could be necessary... 
> 
> I know, it's not a trivial issue.  It's ugly.  And I don't think that
> you could ever put ranges in the hashtable.  However, you could provide
> a high-layer function that 
> 
> - locks the htable
> - tries to allocate as many reservations as there are in the range,
>   contiguously
> - unlocks the htable
> 
> In normal cases, we would only have 2 or 4 (maybe 8) consecutive port
> numbers to allocate.  So it is feasible to put each of them into the
> hash.  This would not give a slowdown at checking / lookup time.
 >
>>Cannot problems like these solved by allowing more 
>>than one reservation per expectation to be registered?
> 
> The problem is, that then there is no atomicity.  They really need to be
> consecutive.  
> 
> So from the implementation point of view: yes, they are multiple
> seperate reservations.  But from an API point of view, it should be a
> single call.

   So, you propose something like this:

   ip_nat_reserved_register_range(struct ip_conntrack_expect *expect,
				 struct ip_nat_range *range);

   ip_nat_reserved_unregister_range(struct ip_conntrack_expect *expect,
				   struct ip_nat_range *range);

   It should grab the lock protecting the reserved hash, check if anything 
in that range is already reserved, and register the manips one-by-one.

   Oh, and one possible problem: although NAT won't allocate a reserved 
tuple as unique, a connection which is not NAT-ted can still clash with 
the reservation... How the heck could this be checked?

-- 
   Regards,
     Krisztian KOVACS
