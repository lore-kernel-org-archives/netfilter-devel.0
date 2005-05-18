From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 18 May 2005 08:08:40 +0100
Message-ID: <428AE9F8.6050906@ufomechanic.net>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net> <4278B23A.7050406@trash.net>
	<4278B98E.7090707@ufomechanic.net> <427B8A46.8090006@trash.net>
	<427D26E7.8060701@ingate.com> <427D3EAF.3020200@trash.net>
	<427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<428A1807.8070708@ufomechanic.net>
	<Pine.LNX.4.58.0505180842420.9582@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0505180842420.9582@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:

>On Tue, 17 May 2005, Amin Azez wrote:
>
>  
>
>>KOVACS Krisztian wrote:
>>    
>>
>>>  Probably Patrick was referring to a possible problem where the
>>>following happens: a new connection is established and destroyed in a
>>>very short time. If a new connection with the same tuple is created
>>>before the timestamp increases (which is perfectly possible IMHO if you
>>>have some slow embedded HW with no high precision timer available)
>>>      
>>>
>>After further reading I think this scenario is highly unlikely.
>>
>>I don't mean improbable, I mean, is there any such hardware?
>>If a socket is not to be reused until TCP_TIME_WAIT which is recommended
>>to be in the region of 4 minutes, is there really any hardware that
>>can't time to that resolution? Is there really any devices that will
>>re-use a TCP socket in the same timer tick as they closed it?
>>    
>>
>
>We have to deal with other protocols as well, not just TCP. For example
>using UDP one could fairly easily trigger the described situation.
>
>  
>

I think this situation could not be triggered by UDP, as there are no 
explicit close sequences for udp that conntrack recognizes, so the 
conntrack would only be destroyed after a conntrack timer expires (which 
must be larger than the minimum resolution of the timer), therefore it 
becomes impossible to bring up two conntracks with the same tuples in 
the same clock tick.

Amin
