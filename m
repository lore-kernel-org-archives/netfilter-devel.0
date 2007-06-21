From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] add TCP protocol state event groups
Date: Thu, 21 Jun 2007 18:04:44 +0200
Message-ID: <467AA19C.8000906@trash.net>
References: <466D8EEB.9080601@netfilter.org> <4677DB3F.8010901@trash.net>
	<4677E47F.7010004@netfilter.org> <4677EBEB.9010905@trash.net>
	<4679613B.6040100@netfilter.org> <467966A8.4060405@trash.net>
	<467A9D9F.7070507@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467A9D9F.7070507@netfilter.org>
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
>>So far I presume conntrackd still listens to the global group. So
>>I would like to know how many groups we'll end up with until this
>>scheme is really fine-grained enough that it allows conntrackd
>>to avoid listening to the global group and what types of events
>>it would ignore (so I can understand the performance improvement
>>this might yield). The above still only contains protocol specific
>>groups.
> 
> 
> OK, let me develop the issue a bit more. In my initial experiments, I
> used the patch to replicate only TCP connections, so conntrackd was not
> listening the global group but just TCP state events. I currently have a
> clause that looks like:
> 
> Replicate ESTABLISHED TIME_WAIT for TCP
> 
> Thus, only established and time_wait states are replicated. My plan is
> to add similar clauses for other protocols so:


Is that set of states useful in real-life? How are connections
destroyed?

> Replicate ESTABLISHED for STCP


What does this exactly mean? Replicate messages that put the connection
in established state, or replicate all messages that happen while the
connection is in established state?

> Replicate NEW DESTROY for UDP


There aren't any other events for UDP anyway except STATUS
for the assured bit, and I guess you do want to replicate
that as well.

> Replica NEW DESTROY for UNCLASSIFIED


Same here, assuming UNCLASSIFIED will be proto generic in the
end.

Again, what I would like to understand before we add something
we have to live with forever is what it will look like in the
end and what the gain of it is, so I would like to see a realistic
example. Since the vast majority of updates is in TCP ESTABLISHED
state and basically everyone is going to synchronize that I have
a hard time believing that this is really going to give a notable
performance improvement.

I also only see new groups related to protocol states, what
about helpers, timeouts, ...?
