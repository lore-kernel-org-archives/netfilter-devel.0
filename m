From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Tue, 17 May 2005 22:17:05 +0200
Message-ID: <428A5141.20901@trash.net>
References: <424747E3.7000300@eurodev.net>	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	<42789366.20702@ufomechanic.net>	<4278B23A.7050406@trash.net>	<4278B98E.7090707@ufomechanic.net>	<427B8A46.8090006@trash.net>	<427D26E7.8060701@ingate.com>
	<427D3EAF.3020200@trash.net>	<427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<428A1807.8070708@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <428A1807.8070708@ufomechanic.net>
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

Amin Azez wrote:
> KOVACS Krisztian wrote:
> 
>>   Probably Patrick was referring to a possible problem where the
>> following happens: a new connection is established and destroyed in a
>> very short time. If a new connection with the same tuple is created
>> before the timestamp increases (which is perfectly possible IMHO if you
>> have some slow embedded HW with no high precision timer available) 

Exactly.

> After further reading I think this scenario is highly unlikely.

Unlikely is still enough reason to handle it properly in an API.
Otherwise anything you build on top of it has to take this into
account for any guarantees it would like to give. And so far, I
haven't even seen a suggestion how to notice it - which would
also be fine with me.

Regards
Patrick
