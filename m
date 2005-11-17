From: Menno Smits <menno@netboxblue.com>
Subject: Re: Simulatenous use of LOG and ULOG on 2.6.14
Date: Fri, 18 Nov 2005 08:23:53 +1000
Message-ID: <437D02F9.9020107@netboxblue.com>
References: <436EF34E.2030806@netboxblue.com>
	<20051112101727.GC10584@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051112101727.GC10584@sunbeam.de.gnumonks.org>
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

Hi Harald,

> The idea is that in the long term there will only be one LOG target
> that everybody uses.

Ok, thanks for confirming this.

> One thing that I've been thinking about, though, was having
> priorities. So when you use ULOG/NFLOG and your daemon dies, it would
> fall back to the LOG/dmesg backend, if that is available.

Interesting idea but not too useful for us. We'd like to have syslogging
and ULOG/NFLOG at the same time.

The problem has been worked around by assigning a specific ULOG netlink
group for traffic to be "syslogged" and using a simple daemon to
collect, parse and log these packets.

>> How do I make this work as before? I need to be able to use both
>> ULOG and LOG at the same time. Will it work if enable
>> CONFIG_NETFILTER_NETLINK and related options and port the daemon to
>> the new libnetfilter_log library? I'd really prefer to not have to
>> touch the daemon at this stage but will if that's the only answer.
> 
> 
> no, it wouldn't be any different.

Great. I have since confirmed that this is true. Our existing logging
daemon still works.

Menno

Scanned by the NetBox from NetBox Blue
(http://netboxblue.com/)
