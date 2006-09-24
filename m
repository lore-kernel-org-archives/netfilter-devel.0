From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3][CONNTRACK] Introduce the pickup facilities to take
 over TCP connections
Date: Sun, 24 Sep 2006 05:46:18 +0200
Message-ID: <4515FF8A.4060905@netfilter.org>
References: <44E972E1.4080500@netfilter.org>
	<Pine.LNX.4.64.0608211214120.25230@bizon.gios.gov.pl>
	<44EA11C1.2090705@netfilter.org>
	<Pine.LNX.4.64.0608212359410.3014@bizon.gios.gov.pl>
	<44EA3DF0.9040104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44EA3DF0.9040104@trash.net>
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

Sorry for the delay in the reply, I've been overloaded with work. This
thread is important for conntrackd

Patrick McHardy wrote:
> Krzysztof Oledzki wrote:
>> On Mon, 21 Aug 2006, Pablo Neira Ayuso wrote:
>>
>>> You seem to be confused with the IPS_PICKUP flag: this flag must be
>>> set for conntracks created from userspace via ctnetlink, thus the TCP
>>> window tracking knows that it has to take over the valid window of TCP
>>> sequences, once that happens this flag is unset.
>>
>> Hm, lets assume we have two firewalls for active-active configuration.
>> How does the second firewall know that it should accept/drop a packet
>> with specific seq number from connection that was previously handled by
>> the first one?
>>
>> Plase excuse me if this is obvious, but I wasn't able to find any
>> information about how it was solved. All I found is the TODO file
>> with:
>>
>> o support for TCP window tracking
>>         - at the moment you have to disable it:
>>         echo 1 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal
> 
> 
> I think the question is whether connections will bounce between nodes
> multiple times or just once when a node fail. The former would need
> to have the IPS_PICKUP flag constantly enabled.

conntrackd bounces the connections to the other node iff a the node
fails, so the flag needs to be enabled once in the creation of the
entry. BTW, conntrackd supports up to 2 nodes for active-active settings
at the moment, although I consider that this limitation is easy to
overcome: we can use a hash based approach similar to clusterip. Say we
have three nodes:

node A, id 0
node B, id 1
node C, id 2

x = hash(tuple) % number of nodes
if (x == my_id)
     process connection
else
     ignore connection
fi

@Patrick: BTW, thanks for mangling the cleanup patch for ctnetlink (dump
[+ clear counter] code), I was about to resend but you were faster, I
really get annoyed myself with these little mistakes :(

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
