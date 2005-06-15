From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 15 Jun 2005 04:41:01 +0200
Message-ID: <42AF953D.3030308@eurodev.net>
References: <424747E3.7000300@eurodev.net> <4254258E.5000204@eurodev.net>
	<42627BC4.8070103@trash.net>
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
	<Pine.LNX.4.58.0506130908500.20636@blackhole.kf
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.62.0506140433070.4718@kaber.coreworks.de>
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

Patrick McHardy wrote:
> On Tue, 14 Jun 2005, Pablo Neira wrote:
> 
>>> At dumping we could use the flip-bit solution: entries which are already
>>> dumped were marked with the next value of the bit. Of course user 
>>> requests
>>> for dumping must be serialized, but conntrack replication could benefit
>>> from such schema, because new entries could be added to the conntrack
>>> table and replicated during full conntrack table replication as well.
>>
>>
>> Could you elaborate this idea about the flip-bit solution, please? 
>> looks interesting.
> 
> 
> You only allow one process to dump the table at a time, In each
> conntrack entry you flip a bit when dumping it. When continuing
> you continue with the next entry that has the bit unflipped.
> This way you don't need an ID at all. You need a timeout to make
> sure a hung process isn't blocking dumps forever. A malicious
> acting process could probably still block others for a long time,
> but dumping the conntrack table should only be possible with
> root priviliges anyway. When a dump is interrupted the state of
> the bits is inconsistent, in this case you need to reset all of
> them to a known state.

This would complicate the logic. Moreover, a top-like processing dumping 
the conntrack table every x seconds could be such "evil" process. I'm 
going to stuck on the idea of using a u64 id. It's the simpler solution 
at the moment.

--
Pablo
