From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 20:17:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9426C1.6070908@trash.net>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com> <3F934FFD.7090700@trash.net> <20031020071545.GA21521@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031020071545.GA21521@sunbeam.de.gnumonks.org>
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

>On Mon, Oct 20, 2003 at 05:01:17AM +0200, Patrick McHardy wrote:
>
>>- we can use some sorting algorithm which benefits from pre-sorted 
>>input. this would give better average performance. IIRC new conntracks
>>are added at the head of the chains, so if we sort and walk backwards
>>through the chains we only have to resort after an id counter wrap.
>>    
>>
>
>this works with a 64bit counter, but doesn't with my proposed generation
>counter.  the generation counter has two advantages:
>- no global counter, just the counter field in every conntrack
>- less size increase of struct ip_conntrack. 
>
>Oh well, yes.  We have to think about the slab cache returning objects
>to the 'real' memory allocator.  Then our generation counter would
>become useless.  Don't know if it is reliable enough to initialize the
>counter with a random 32bits in that case.  How high is the  probability
>of re-using the recently-used counter in that case?
>

Actually with 64 bit the wrap-around time is so large we would never 
have to resort.

>>I agree, we should use 64 bit.
>>    
>>
>
>I feel like I have to cry.  As soon as we add any kind of counter (be
>it 32 or 64 bits), we would definitely have to make it a compile time
>option.  My vision of ctnetlink was something like a match extension:
>You can always compile it as a module, and it wouldn't hurt performance
>as long as you don't load it.
>  
>

I understand your objections, It is really not my intend to enlarge 
struct ip_conntrack without
the need to do so. However I'd rather save some memory by f.e. making 
helper memory
dynamic than by saving these couple of bytes and making some 
functionality of ctnetlink
somewhat useless. Compiling as a module without performance penalty 
won't work anyways
as soon as you enable event notifications.

So do I understand correctly we're at the point were we agree we need to 
add something
to struct ip_conntrack and either use a linear increasing global counter 
or a generation count
which increases as soon as we return something to the slab.

Advantages/Disadvantages of global counter:
- don't need any sorting with 64bit, natural sorting is fine
- uniquely identifies conntracks without risk of collisions
- possible contention on global counter

Advantages of generation count:
- No global counter
- probably expensive sorting needed over time
- no unique identity, can not be used from userspace

I still favour the global counter but I'm fine as long as dumping works, 
a unqiue identity for
userspace is less important. I'd say it's up to you to decide.

Best regards,
Patrick
