From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Possible 'destroy' paths for conntracks?
Date: Mon, 7 Mar 2005 08:18:03 -0500
Message-ID: <876ef97a0503070518172b7387@mail.gmail.com>
References: <422C1FA6.5030701@expertron.co.za>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Justin Schoeman <justin@expertron.co.za>
In-Reply-To: <422C1FA6.5030701@expertron.co.za>
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

On Mon, 07 Mar 2005 11:32:22 +0200, Justin Schoeman
<justin@expertron.co.za> wrote:
> I am trying to locate a memory leak, either induced by, or agravated by
> the l7-filter.
> 
> Using the slab debugger, I see that the memory that is leaking are the
> app_data and/or app_proto fields that are kmalloc'ed in the 'match' method.
> 
> These are then (supposed to be) kfree'ed in the destroy_conntrack
> function, but they are apparently not destroyed, as even after most
> active connections have closed/timed out (/proc/net/ip_conntrack is
> practically empty), there are still thousands of these kmalloced memory
> regions left.
> 
> At the moment, I am assuming that there are multiple possible paths for
> a conntrack to be destroyed, and l7-filter is just missing some.  Is
> this true?  If so, what are all the possible destructors, or is there
> one single (better) place to clean up per-conntrack specific memory?

No, destroy_conntrack() is the sole location of conntrack record
destruction. If you follow any conntrack record deletion routine, it
will hit destroy_conntrack() at some point. What kernel version are
you using and what patches have you applied? What version of l7-filter
are you using? The destroy_conntrack() function doesn't know anything
about filter-specific allocations, so if the allocations are not
destroyed in the protocol-specific deletion handler, they will not be
destroyed. How is l7-filter registering its delete functionality for
these memories? Is it doing so at all?

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
