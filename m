From: Martijn Lievaart <m@rtij.nl>
Subject: Re: ip_conntrack_tuple and marks
Date: Mon, 25 Sep 2006 00:03:29 +0200
Message-ID: <451700B1.7070103@rtij.nl>
References: <451448A9.6000407@gmx.net> <4515F7F8.9030000@netfilter.org>
	<4516C70A.3050502@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <4516C70A.3050502@gmx.net>
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

Carl-Daniel Hailfinger wrote:

>Pablo Neira Ayuso wrote:
>  
>
>>Carl-Daniel Hailfinger wrote:
>>    
>>
>>>is it possible to add a nfmark field to ip_conntrack_tuple
>>>so that only packets with a certain mark set are matched to
>>>a connection? I'm trying to filter/nat multiple independent
>>>connections with same ip/proto/port tuples on both sides
>>>and the only distinguishing property of the different
>>>connections is their nfmark. Using NOTRACK doesn't help
>>>because it can only exclude packets from tracking, not
>>>match packets to different expectations.
>>>      
>>>
>>Could the connmark match/target be what you need?
>>    
>>
>
>Unfortunately, connmark does exactly the opposite of what
>I'm trying to achieve.
>
>connmark: get/set fwmark based on flow
>my problem: handle different flows with identical
>  srcip/dstip/sport/dport/proto tuples where the only
>  difference is the packet fwmark
>
>Example (what I hope to get working)
>SYN packet from 10.0.0.1:1024->10.0.0.2:80 fwmark 1 creates
>one connection.
>SYN packet from 10.0.0.1:1024->10.0.0.2:80 fwmark 2 creates
>another connection independent of the first. Current netfilter
>code considers both packets to belong to the same connection.
>
>  
>

Because they are the same connection! What on earth are you trying to 
achieve? What strange setup do you have where these packets do *not* 
belong to the same connection? Mind you, that's not only netfilter, the 
recieving box will also see these packets as belonging to the same 
connection.

HTH,
M4
