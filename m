From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Tue, 14 Jun 2005 04:30:06 +0200
Message-ID: <42AE412E.8080407@eurodev.net>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net> <4278B23A.7050406@trash.net>
	<4278B98E.7090707@ufomechanic.net> <427B8A46.8090006@trash.net>
	<427D26E7.8060701@ingate.com> <427D3EAF.3020200@trash.net>
	<427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<428A1807.8070708@ufomechanic.net> <428A5141.20901@trash.net>
	<Pine.LNX.4.58.0505180948180.9582@blackhole.kfki.hu>
	<42A23EDA.2090307@eurodev.net> <42A24F3B.8050607@eurodev.net>
	<Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>
	<42A83B96.4050302@eurodev.net> <42A83D72.1000106@eurodev.net>
	<Pine.LNX.4.58.0506091519580.7610@blackhole.kfki.hu>
	<42A9698F.30909@eurodev.net>
	<Pine.LNX.4.58.050
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506130908500.20636@blackhole.kfki.hu>
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

Hello Jozsef,

Jozsef Kadlecsik wrote:
> On Fri, 10 Jun 2005, Pablo Neira wrote:
> 
> 
>>>How are you going to handle id collision due to wraparound?
>>
>>yes, 8 bits is too short. About the wraparound problem, I'm planning to
>>re-use id's. The id of a new conntrack will be set to the lastest
>>inserted in the bucket plus one.
>>
>>However this wouldn't uniquely identify a conntrack: Say a connection is
>>established, lastest conntrack in the bucket uses id A, so its id will
>>be set to A+1. After quite some time the connection is closed. Then, in
>>a very short period of time, another connection with the same tuples is
>>established and lastest conntrack id is still A, in that case the id of
>>the new conntrack will be set to A+1 again.
> 
> 
> Wouldn't be more straightforward to store the last assigned id value in
> the bucket and simply increment that whenever the next value is used up?
> (Id collision is actually not a big problem, because the entries are
> identified by the tuples in the first place.)

Right, but then I'll have to face another problem, once the wraparound 
happens the conntracks inserted in the bucket aren't ordered by the id 
anymore. Currently if the skbuff that is going to be sent to user space 
via netlink gets full (one page sized), I'll need to know which was the 
lastest processed conntrack, including possible race conditions, ie. the 
conntrack expires while netlink is returning the packet to user space. 
This is controled by the following branch while iterating over the list:

                         if (ct->id <= cb->args[1])
                                 continue;

That's why I came up with the idea of re-using id's, I want to avoid a 
wraparound. BTW, inserting conntracks in order isn't a solution either, 
since this will break LRU early drop.

> At dumping we could use the flip-bit solution: entries which are already
> dumped were marked with the next value of the bit. Of course user requests
> for dumping must be serialized, but conntrack replication could benefit
> from such schema, because new entries could be added to the conntrack
> table and replicated during full conntrack table replication as well.

Could you elaborate this idea about the flip-bit solution, please? looks 
interesting.

I'm still looking for a solution based on a simpler logic, we'll see ;).

--
Pablo
