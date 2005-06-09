From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Thu, 09 Jun 2005 14:52:38 +0200
Message-ID: <42A83B96.4050302@eurodev.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>
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
>>>I'd definitely like to have such accuracy, but I still see this incident
>>>unlikely. I think that such TCP stack must be broken if it starts a
>>>brand new connection using the same source/destination ports that it's
>>>recently used.
>>
>>Forget this, this can happen in an attempt to reopen a closed
>>connection, and such case is likely. We need such ID in order to achieve
>>accuracy. I think that it must be the user who has to choose if he wants
>>accuracy or not, in such case we have to provide the corresponding
>>methods to achieve it. A user could kill a conntrack by means of:
>>
>>a) the tuples, if he doesn't want accuracy
>>b) the tuples + the id, if he does.
> 
> 
> I share your feelings about giving complete accurate access to the users
> over conntrack entries. Still, I'm not completely convinced about the
> practical usefulness of such accuracy. Let's therefore look at it again:
> 
> a. Policy changed and admin wants to enforce the new policy on the living
>    conntrack entries as well: here the id does not buy anything, tuples
>    are just sufficient.
> b. Admin wants to kill a "stuck" conntrack entry, in order to make
>    possible to build up a new connection. In my opinion that's just not
>    the proper way to deal with the problem, conntrack should be able to
>    handle such cases automatically. And I believe we worked very hard
>    and that part is highly polished in conntrack in the recent 2.6
>    tree, so that it's just a theoretical example ;-)
> c. conntrack table is full and admin wants to get rid of a bunch of
>    entries manually. Somehow I don't think id would be very useful here
>    either.
> 
> Other possibilities?
> 
> I do not think users should poke conntrack without very good reason, at
> their whim.

Agreed, those scenarios look pretty realistic.

But if the ID goes out, I'll have another concern. 
ctnetlink_dump_table[_w] currently uses the ID to know where it's 
stopped dumping the conntrack table, netlink dumping is not atomic. I 
could increase the conntrack refcount and hold a pointer to it but if 
timeout expires while returning data to user space, the conntrack won't 
be in hashes anymore, so it couldn't continue the travel through the 
conntrack table.

I thought about freezing the conntrack timer and active it once I 
continue traversing the list. That could result in problems since 
netlink dumping is not atomic, someone could interrupt the dumping and 
that conntrack will be stuck there forever. Moreover, I don't like it.

All the things I've though so far are burned by something. The cleanest 
way to do this looks the ID. Any other ideas?

P.D: Thanks to Krisztian Kovacs for the feedback.

--
Pablo
