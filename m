From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Fri, 10 Jun 2005 12:21:03 +0200
Message-ID: <42A9698F.30909@eurodev.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506091519580.7610@blackhole.kfki.hu>
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

Hi Jozsef,

Jozsef Kadlecsik wrote:
>>Pablo Neira wrote:
>>
>>>All the things I've though so far are burned by something. The cleanest
>>>way to do this looks the ID. Any other ideas?
>>
>>Hm, this idea just came to my head. We could use a unsigned 8 bit
>>per-bucket-id [blah... blah... blah]
> 
> Let the id be at least unsigned 16 bit. No hash function can guarantee
> that a given bucket won't happen to grow above 256 entries.
> 
> How are you going to handle id collision due to wraparound?

yes, 8 bits is too short. About the wraparound problem, I'm planning to 
re-use id's. The id of a new conntrack will be set to the lastest 
inserted in the bucket plus one.

However this wouldn't uniquely identify a conntrack: Say a connection is 
established, lastest conntrack in the bucket uses id A, so its id will 
be set to A+1. After quite some time the connection is closed. Then, in 
a very short period of time, another connection with the same tuples is 
established and lastest conntrack id is still A, in that case the id of 
the new conntrack will be set to A+1 again.

To avoid that, I could keep an array of lastest id's released per bucket 
and set the id based on:

if (id_of_lastest_ct_inserted > lastest_id_released[bucket])
	id_of_lastest_ct_inserted + 1
else
	lastest_id_released[bucket] + 1;

About memory comsumption. On my laptop, ip_conntrack version 2.1 (1787 
buckets, 14296 max)

This approach:
1787 * 2 = 3574 extra bytes to store the lastest id used
14296 * 2 (extra bytes per conntrack) = 28592 extra bytes (worst case)

With regards to current u64 id approach:
28592 * 8 (extra bytes per conntrack) = 228736 extra bytes (worst case)

--
Pablo
