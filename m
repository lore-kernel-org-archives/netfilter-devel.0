From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] ctnetlink events drop benchmark
Date: Wed, 14 Jun 2006 20:36:10 +0200
Message-ID: <4490571A.5070102@trash.net>
References: <448ED2DD.30100@netfilter.org> <44901551.8080400@trash.net>
	<44903BA5.4030405@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44903BA5.4030405@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>> http://people.netfilter.org/pablo/ctnetlink/events.eps
>>
>>
>> Does "events" mean events/s?
> 
> 
> No, sorry, it seems that the graph is definitely misleading :(. Have a
> look at http://people.netfilter.org/pablo/ctnetlink/107520.txt


I can't seem to find the number of drops in that table, which I thought
this test was all about :) I did some plotting with the numbers myself,
comparing (1):(2)/(1) with (1):(3)/(1) (actually / 6.353 to scale the
initial UPDATE value down to NEW) shows that UPDATE events scale much
more linear than NEW events, which could either mean they get dropped
more for some reason or that the connections had a higher number of
packets in the runs with more connections (possibly because of more
retransmissions). I think we need the number of packets per connection
to make sense out of the data.
