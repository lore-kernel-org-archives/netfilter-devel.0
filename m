From: Patrick McHardy <kaber@trash.net>
Subject: Re: states worth to replicate [was Re: [PATCH] add TCP protocol
 state event groups]
Date: Fri, 22 Jun 2007 14:49:21 +0200
Message-ID: <467BC551.2060602@trash.net>
References: <466D8EEB.9080601@netfilter.org> <4677DB3F.8010901@trash.net>
	<4677E47F.7010004@netfilter.org> <4677EBEB.9010905@trash.net>
	<4679613B.6040100@netfilter.org> <467966A8.4060405@trash.net>
	<467A9D9F.7070507@netfilter.org> <467AA19C.8000906@trash.net>
	<467ACD6B.2020009@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467ACD6B.2020009@netfilter.org>
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
>>>Replicate ESTABLISHED TIME_WAIT for TCP
>>>
>>>Thus, only established and time_wait states are replicated. My plan is
>>>to add similar clauses for other protocols so:
>>
>>Is that set of states useful in real-life? 
> 
> 
> I think so. In general, syn states have a very short lifetime. Thus,
> they are quickly superseded by established, making the replication
> effort barely useful. Moreover, I assume that clients usually reissue
> connections that fail in (early) syn states. I'm assuming that we are
> focusing on the recovery of connection established.
> 
> 
>>How are connections destroyed?
> 
> 
> Once we received the time_wait, we tell other replicas to destroy the
> connection. We miss previous teardown states that have also short
> lifetime. This is a tradeoff, we reduce the "copy-equivalence" degree
> among replicas but reduce the number of messages generated in return.


Connections don't go through TIME_WAIT in case they are reset.

>>Again, what I would like to understand before we add something
>>we have to live with forever is what it will look like in the
>>end and what the gain of it is, so I would like to see a realistic
>>example. Since the vast majority of updates is in TCP ESTABLISHED
>>state and basically everyone is going to synchronize that I have
>>a hard time believing that this is really going to give a notable
>>performance improvement.
> 
> 
> Well, since there is usually just one messages per state change in the
> case of TCP connections, we would just generate two, one to notify the
> established state and one to destroy it. Thus, in the particular case of
> a HTTP connection, we would need just two messages instead of seven.
> 
> 
>>I also only see new groups related to protocol states, what
>>about helpers, timeouts, ...?
> 
> 
> Same thing as above, the protocol events groups are just a way to group
> events. Thus, if the conntrack mark changes while in established state,
> an event message to the established group is delivered.


Mhh OK. I'll think about it some more over the weekend.

Something not directly related: we're generating events (internally)
for every packet and call the notifiers, yet we don't use them for
anything (for example IPCT_PROTOINFO_VOLATILE and IPCT_REFRESH),
which seems like a complete waste. I think we should remove them.
