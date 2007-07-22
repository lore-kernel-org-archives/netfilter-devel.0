From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: REDIRECT and IPv6
Date: Sun, 22 Jul 2007 21:22:52 +1200
Message-ID: <46A321EC.6060403@treenet.co.nz>
References: <1246.130.217.140.56.1184804730.squirrel@webmail.treenet.co.nz>	<469F280B.3070900@trash.net>
	<200707190948.l6J9mk02018250@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707190948.l6J9mk02018250@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 19 Jul 2007 10:59:55 +0200
> 
>> squid3@treenet.co.nz wrote:
>>> Greetings,
>>>
>>> Pardon if this is a dumb question. But I have searched the web, and the
>>> source code for a solution to this one and have reached a brick wall.
>>>
>>> I'm upgrading a user-space proxy (squid3) which has in the past done
>>> transparent connections under IPv4-only using SO_ORIGINAL_DST.
>>>
>>> The Firewall/router uses iptables and REDIRECT port 80 outbound to port
>>> 81. All is fine and dandy when squid listens on 0.0.0.0:81.
>>>
>>> With the new code I have to use an IPv6 socket ( [::]:81 ) as the
>>> receiver. With that getsockopt(..., SO_ORIGINAL_DST, ...) always returns
>>> err "92 Protocol not supported." regardless of the IP-level parameters
>>> passed in.
>>>
>>> NOTE: All traffic for testing so far has been from IPv4 clients to what
>>> they think is an IPv4 server, but with a dual-enabled middleman. The
>>> 'middleman' Software is iptables 1.3.6 on Debian 2.6.21-2-486 (unstable),
>>> squid3 built with g++ 4.1.3.
>>
>> You're right, nf_conntrack_ipv4 only registeres SO_ORIGINAL_DST for
>> AF_INET, changing that should make it work I believe. I feel like
>> I'm missing something though ..
> 
> I wrote getorigdst() for IPv6 at once but threw away it
> because of no IPv6 NAT :) I hope that new tproxy will support IPv6 in future.
> 
> -- Yasuyuki Kozakai


Thanks for everything people.

Well, obviously the REDIRECT is working despite no IPv6 NAT.
What sort of a timeframe should I expect before this case is working?

Amos
