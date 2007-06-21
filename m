From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: states worth to replicate [was Re: [PATCH] add TCP protocol state
 event groups]
Date: Thu, 21 Jun 2007 21:11:39 +0200
Message-ID: <467ACD6B.2020009@netfilter.org>
References: <466D8EEB.9080601@netfilter.org> <4677DB3F.8010901@trash.net>
	<4677E47F.7010004@netfilter.org> <4677EBEB.9010905@trash.net>
	<4679613B.6040100@netfilter.org> <467966A8.4060405@trash.net>
	<467A9D9F.7070507@netfilter.org> <467AA19C.8000906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467AA19C.8000906@trash.net>
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
> Pablo Neira Ayuso wrote:
>> OK, let me develop the issue a bit more. In my initial experiments, I
>> used the patch to replicate only TCP connections, so conntrackd was not
>> listening the global group but just TCP state events. I currently have a
>> clause that looks like:
>>
>> Replicate ESTABLISHED TIME_WAIT for TCP
>>
>> Thus, only established and time_wait states are replicated. My plan is
>> to add similar clauses for other protocols so:
> 
> Is that set of states useful in real-life? 

I think so. In general, syn states have a very short lifetime. Thus,
they are quickly superseded by established, making the replication
effort barely useful. Moreover, I assume that clients usually reissue
connections that fail in (early) syn states. I'm assuming that we are
focusing on the recovery of connection established.

> How are connections destroyed?

Once we received the time_wait, we tell other replicas to destroy the
connection. We miss previous teardown states that have also short
lifetime. This is a tradeoff, we reduce the "copy-equivalence" degree
among replicas but reduce the number of messages generated in return.

>> Replicate ESTABLISHED for STCP
> 
> What does this exactly mean? Replicate messages that put the connection
> in established state, or replicate all messages that happen while the
> connection is in established state?

Replicate all messages that happen while the connection is in
established state. So, the protocol groups are just a different way to
group events.

>> Replicate NEW DESTROY for UDP
> 
> There aren't any other events for UDP anyway except STATUS
> for the assured bit, and I guess you do want to replicate
> that as well.

Right. In this case, I think that it would be worth replicating assured
and destroy states.

>> Replica NEW DESTROY for UNCLASSIFIED
> 
> Same here, assuming UNCLASSIFIED will be proto generic in the
> end.

Same thing as above.

> Again, what I would like to understand before we add something
> we have to live with forever is what it will look like in the
> end and what the gain of it is, so I would like to see a realistic
> example. Since the vast majority of updates is in TCP ESTABLISHED
> state and basically everyone is going to synchronize that I have
> a hard time believing that this is really going to give a notable
> performance improvement.

Well, since there is usually just one messages per state change in the
case of TCP connections, we would just generate two, one to notify the
established state and one to destroy it. Thus, in the particular case of
a HTTP connection, we would need just two messages instead of seven.

> I also only see new groups related to protocol states, what
> about helpers, timeouts, ...?

Same thing as above, the protocol events groups are just a way to group
events. Thus, if the conntrack mark changes while in established state,
an event message to the established group is delivered.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
