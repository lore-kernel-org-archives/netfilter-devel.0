From: Amin Azez <azez@ufomechanic.net>
Subject: extending conntrack event data
Date: Thu, 21 Apr 2005 10:25:20 +0100
Message-ID: <42677180.60003@ufomechanic.net>
References: <20050419212858.039E.LARK@linux.net.cn>
	<42665BF9.9090707@ufomechanic.net> <4266DB3A.8060106@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4266DB3A.8060106@eurodev.net>
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

I realise that I may be extending the scope of ctevent too far for some, 
but I would like to make some more info available for conntrack events.

Specifically: mac addresses, and the time stamp associated with the skb 
that triggered the conntrack event.

notifier_call_chain in include/linux/netfilter_ipv4/ip_conntrack.h 
extacts the ip_conntrack from the skb and passes that to each event 
callback.
As notifier_call_chain is not passed the addresses of any members of the 
skb the callback can't use any container tricks to extract the skb address.
For my own convenience, and for compatability, I would like to modifer 
notify_call_chain to pass the skb address as a 4th parameter so that 
callback handlers may receive it. How do others feel about this?

Also, I realise that at the moment the mac member of an sk_buff presumes 
that all mac info will be ethernet; however I would like to write clean 
code that does not presume this will always be the case. What is the 
best way to check from an sk_buff that the link layer is ethernet, or 
rather that it is valid to presume that sk->mac.raw points to an ethhdr 
(if not null)?  The best I could think of was sk->inputdev but this 
seems to have no members to indicate device type. Is it true that the 
kernel only supports ethernet-type devices, or devices that masquerade 
as ethernet type devices?

Finally, I know the issue of conntrack id's has been discussed before, 
and that in kernel space the tuples are actually the best way to relate 
skb's to conntracks. I realise that tuple contents could also be used to 
maintain user-space references there is a race condition that exists; if 
a user-space application requests some action on a conntrack or related 
connection, because by the time this instruction is acted on in the 
kernel it might be applied to a different actual connection with the 
same tuple (previous connection has been closed). As netlink/netfilter 
stuff introduces more user-space connection management capabilities, we 
surely need to consider this problem?

Amin
