From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Mon, 09 May 2005 16:08:49 +0100
Message-ID: <427F7D01.1090206@ufomechanic.net>
References: <424747E3.7000300@eurodev.net>	<42502F8D.5030504@trash.net>	
	<4254258E.5000204@eurodev.net>	<42627BC4.8070103@trash.net>	
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	
	<42789366.20702@ufomechanic.net>	<4278B23A.7050406@trash.net>	
	<4278B98E.7090707@ufomechanic.net>	<427B8A46.8090006@trash.net>	
	<427D26E7.8060701@ingate.com> <427D3EAF.3020200@trash.net>	
	<427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Marcus Sundberg <marcus@ingate.com>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1115648236.25627.17.camel@nienna.balabit>
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

KOVACS Krisztian wrote:

>
>  OK, but it's not a problem. If the two conntracks are identical (their
>tuples are the same) then equal timestamps are not a problem (and of
>course one of them will be dropped anyway, since hash insertion is
>serialized). If they are not the same, then it does not matter because
>the timestamp is just an additional info -- the tuple identifies the
>conntrack by itself.
>
>  Probably Patrick was referring to a possible problem where the
>following happens: a new connection is established and destroyed in a
>very short time. If a new connection with the same tuple is created
>before the timestamp increases (which is perfectly possible IMHO if you
>have some slow embedded HW with no high precision timer available) then
>you won't be able to tell the difference in the userspace app, so that
>the race described by Amin is still possible.
>  
>
The time struct used in skb's has time and microtime.
Is there a sequence of packets that conntrack could monitor so that a 
conntrack to be created and destroyed and re-created in the same 
microsecond?

I can't imagine any slow embedded hardware being called upon to process 
a sequence of packets that occur so quickly; are installations actually 
called upon to process packets at a rate beyond their ability to time? 
(maybe so, just curious)

Perhaps if the conntrack would be destroyed in the same time instance 
that it is created it is instead saved but destroyed later by a timer 
callback.  If a conntrack is then to be "re-created" before it has been 
destroyed, a small starts-at-0 counter in the conntrack struct is 
increased to indicate re-use. The size of this counter would have to 
reflect the number of times a conntrack could be destroyed and 
resurrected in the same timer-tick.

It is sad that the addition of the extra field, and deferral of 
destruction on contracks in the same microsecond they were created in 
make the solution less simple, but they would make it robust.

Amin
