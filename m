From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] new match extension `flow'
Date: Sun, 31 Oct 2004 15:41:49 +0100
Message-ID: <4184F9AD.9040902@eurodev.net>
References: <20041028020550.GA10097@wsc.edu> <41829ADC.2090708@eurodev.net>
	<20041031063813.GA29402@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20041031063813.GA29402@wsc.edu>
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

Josh,

Josh Samuelson wrote:

>On Fri, Oct 29, 2004 at 09:32:44PM +0200, Pablo Neira wrote:
>  
>
>>cool, nice work. But can't we do a match which counts new connections? I 
>>bet that
>>the problem is that we don't know when a connection is closed, maybe we 
>>could add a
>>new ip_conntrack_status (something like IPS_CLOSED_BIT) which would be 
>>set when
>>a connection is closed, i.e. in tcp tracking when in time 
>>TIME_WAIT/FIN_WAIT). I don't
>>like so much the idea of adding more stuff to the core of the conntrack 
>>to keep things simpler.
>>
>>Pablo
>>    
>>
>
>That's what I thought was elegant about this approach, the simplicity.
>Besides the added code needed to set up the memory structures to store
>the counters and the proc entries, there are only two entry points for
>the added code.  One in init_conntrack() -> ip_conntrack_flow_inc(), the
>other in destroy_conntrack() -> ip_conntrack_flow_dec().
>Counter increment/decrement happen closest to when the state
>of the connection tracking actually change.  The cost of this
>code path is always going to contain a hash computation, a linked list
>search to find the structure, then increment/decrement the relevant
>counter.  New and unused old flow structures will have an
>allocation/deallocation and linked list add/delete overhead added to the
>former stated cost.
>
>Later, the match modules that could use the data from these flow structures
>only have to compute a hash/LL search for the structure, then compare the
>data.  No looping through the ip_conntrack_hash to count protocol types,
>meanwhile checking states/timeouts or even invalidating the existence
>of conntracks the match function believes exist against what the
>connection tracking core actually has; executing said process for
>each matched packet.
>  
>

Sure, your solution is smart but I still think we can do that that this 
stuff without adding it to the core of the conntrack. I think that this 
is a perfect client of the event notification API which is *still* in 
development (expect changes).

See: 
https://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017132.html

What I have in mind:

a) Move the flow API as is into a kernel module that implements a match.
b) register two functions which catch IPCT_NEW/RELATED and IPCT_DESTROY 
events. These functions keep updated the hash table with info about 
new/closed connections.

Another issue, AFAICS with your approach we can limit the number of 
connections per machine, but not per network, i.e. limit to 256 tcp 
connections for the whole 192.168.20.0/24, that's a different problem to 
resolve though..

Pablo
