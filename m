From: Justin Schoeman <justin@expertron.co.za>
Subject: Re: Possible 'destroy' paths for conntracks?
Date: Mon, 07 Mar 2005 15:30:38 +0200
Message-ID: <422C577E.707@expertron.co.za>
References: <422C1FA6.5030701@expertron.co.za>
	<876ef97a0503070518172b7387@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a0503070518172b7387@mail.gmail.com>
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

I am currently using 2.6.11 with the updated l7 patch 
(http://www.kegans.com/projects/tcss/files/required/patch-layer7-2.6.11-rc4.diff.bz2) 
and the slab debugging patches (currently only in the lkml archives - I 
can forward it if required).

The interesting thing is that everything worked perfectly in 2.6.8.1 - 
it is only in 2.6.9+ that things started leaking.  Were there any 
significant changes made to the conntrack code in 2.6.9?

Thanks,
Justin


Tobias DiPasquale wrote:
> On Mon, 07 Mar 2005 11:32:22 +0200, Justin Schoeman
> <justin@expertron.co.za> wrote:
> 
>>I am trying to locate a memory leak, either induced by, or agravated by
>>the l7-filter.
>>
>>Using the slab debugger, I see that the memory that is leaking are the
>>app_data and/or app_proto fields that are kmalloc'ed in the 'match' method.
>>
>>These are then (supposed to be) kfree'ed in the destroy_conntrack
>>function, but they are apparently not destroyed, as even after most
>>active connections have closed/timed out (/proc/net/ip_conntrack is
>>practically empty), there are still thousands of these kmalloced memory
>>regions left.
>>
>>At the moment, I am assuming that there are multiple possible paths for
>>a conntrack to be destroyed, and l7-filter is just missing some.  Is
>>this true?  If so, what are all the possible destructors, or is there
>>one single (better) place to clean up per-conntrack specific memory?
> 
> 
> No, destroy_conntrack() is the sole location of conntrack record
> destruction. If you follow any conntrack record deletion routine, it
> will hit destroy_conntrack() at some point. What kernel version are
> you using and what patches have you applied? What version of l7-filter
> are you using? The destroy_conntrack() function doesn't know anything
> about filter-specific allocations, so if the allocations are not
> destroyed in the protocol-specific deletion handler, they will not be
> destroyed. How is l7-filter registering its delete functionality for
> these memories? Is it doing so at all?
> 
