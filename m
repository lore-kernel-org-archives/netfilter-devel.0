From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Patch: add id to libnetfilter_conntrack XML export
Date: Fri, 05 Jan 2007 23:44:56 +0100
Message-ID: <459ED4E8.1000508@netfilter.org>
References: <200701051427.37273.victor.stinner@inl.fr>
	<459E6489.9070307@netfilter.org>
	<200701051618.09855.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Victor Stinner <victor.stinner@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <200701051618.09855.victor.stinner@inl.fr>
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

Hi Victor,

Victor Stinner wrote:
> Le Vendredi 5 Janvier 2007 15:45, vous avez écrit :
>> Victor Stinner wrote:
>>> I heard that connection identifiers may disappear. Is it true? I like
>>> unique identifier because it's small (only 32 bits) and easy to
>>> manipulate. It's hard to identify a connection without such identifier.
>> Indeed, it's planned to get rid of the id. We resolved that the tuple
>> src/dst/port-src/port-dst/l3protonum/l4protonum is enough to identify a
>> conntrack.
> 
> Hum, what is your motivation to remove identifiers? I will be harder to 
> identify a connection: parameters to identify it depends on the layer 3 and 
> layer 4 protocols. (src, dst, port-src, port-dst, l3protonum, l4protonum) 
> doesn't work with ICMP (arguments type and code) :-/ And what about IPv6? 
> What about other layer3 protocols?

The 'id' is not enough to uniquely identify a flow since it can wrap
around: in a scenario with long-time flows, this can result in two flows
with the same 'id'. The 'id' was introduced as a complement for the
tuple since we weren't sure that the tuple was enough to identify a
flow. After several discussions [1], we resolved that the tuple was enough.

For example, conntrackd uses the tuple and keeps the flows in a hash
table, but a different abstract data type could be used (trees).

> I'm working on pyctd and his PHP frontend. To kill a connection (or update a 
> parameter like mark or (fixed) timeout), we just used his identifier.

Talking about pyctd, would you consider integrating this with conntrackd
[2]? That daemon has a statistics mode that can still be improved a lot:
Third party apps can request information such as the whole conntrack
table via UNIX sockets, this can be interesting in scenarios with
heavily loaded firewall since this will not interrupt packet processing
while dumping the conntrack table. Moreover, you can know the connection
lifetime, ie. when did the flow was created, something that is not
available in kernel space, and much more, for example, killing flows
with masks, and other stuff that in kernel space could be overkill. Of
course, this does not come without a price, per-connections counters are
not available. However, I think that the information source (ctnetlink
or conntrackd) for your statistics daemon could be a configurable
parameter, the sysadmin could choose what to use depending on his setup.
BTW, conntrackd doesn't output the flows in XML format yet, but with the
new API that is fairly easy to be implemented.

[1]
http://lists.netfilter.org/pipermail/netfilter-devel/2006-March/023877.html
[2] http://people.netfilter.org/pablo/conntrackd/

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
