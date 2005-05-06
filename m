From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Fri, 06 May 2005 17:16:22 +0200
Message-ID: <427B8A46.8090006@trash.net>
References: <424747E3.7000300@eurodev.net>
	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>
	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net> <4278B23A.7050406@trash.net>
	<4278B98E.7090707@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <4278B98E.7090707@ufomechanic.net>
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
> Patrick McHardy wrote:
>
>> Why is that better than a unique ID? It needs space as well, but can't
>> be used to identify the conntrack without further information.
>>  
>>
> There isn't the problems of having to generate a unique id, or the worry
> of it finally wrapping every few years as we don't pretend it is unique.
> However, combined with either tuple it forms a unique id that wraps only
> when the calendar does.

Wrapping is not a problem with a 64bit id. One thing I'm worried about
with using a timestamp is that it might not be of high enough precision
with very fast CPU and network to uniquely identify each connection.

> Further, as pointed out by Patrick Schaaf, start time has the potential
> to be more useful than a unique id in filtering

Agreed, but it is secondary to solving the problem.

Regards
Patrick
