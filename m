From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Tue, 01 Nov 2005 02:09:05 +0100
Message-ID: <4366C031.6020504@eurodev.net>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de> <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de> <436373E8.7040606@eurodev.net>
	<436398C7.4070402@fliegl.de> <4365A097.1080001@eurodev.net>
	<Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> 1. "Illegal option `-m'" with "conntrack -E -i"
> # conntrack -E -i
> conntrack v0.94: Illegal option `-m' with this command

Wrong error output: this should say `-i'. Fixed.

You can't use -E together with -i. But I think that adding the conntrack 
ID to the event information that is dumped could be worth for accounting 
purposes, so I'll add this to my pending patches for ctnetlink, ok?

> 2. Unable to delete conntrack by id:
> root@olemx:~# conntrack -L -i|grep id=101
> tcp      6 431999 ESTABLISHED src=192.168.0.22 dst=192.168.0.33 
> sport=1607 dport=22 packets=72520 bytes=4421477 src=192.168.0.33 
> dst=192.168.0.22 sport=22 dport=1607 packets=101332 bytes=21675629 
> [ASSURED] mark=0 use=1 id=101
> root@olemx:~# conntrack -D -i 101
> root@olemx:~# conntrack -L -i|grep id=101

You can't kill conntracks *just* by the ID. The connection tracking 
table currently uses the tuple information (source, destination, 
protocol information) to place the conntrack in hashes, same thing to 
perform lookups. Implementing the ability of killing conntracks just by 
its ID would be O(n), so we would need to walk through the buckets until 
we find a matching, not so good. Just a wild thought, how bad would be 
hashing the conntracks by its ID? In that case we could implement this 
feature. So, currently you'll always need the information about the 
source, destination and protocol specific stuff together with the ID.

> tcp      6 431999 ESTABLISHED src=192.168.0.22 dst=192.168.0.33 
> sport=1607 dport=22 packets=72549 bytes=4423573 src=192.168.0.33 
> dst=192.168.0.22 sport=22 dport=1607 packets=101352 bytes=21677725 
> [ASSURED] mark=0 use=1 id=101
> 
> 3. "deficit (4) len (0)." in conntrack -E expect:
> 
> # conntrack -E expect
> 0 proto=17 src=192.168.31.255 dst=192.168.1.29 sport=138 dport=138
> nfnl_parse_attr: deficit (4) len (0).
> 
> 0 proto=17 src=192.168.31.255 dst=192.168.1.227 sport=138 dport=138
> nfnl_parse_attr: deficit (4) len (0).

Fixed in SVN.

> 4. Wrong formating in conntrack -h (Get... & Update...)
> 
> Commands:
> -L [table] [-z]         List conntrack or expectation table
> -G [table] parameters  Get conntrack or expectation
> -D [table] parameters   Delete conntrack or expectation
> -I [table] parameters   Create a conntrack or expectation
> -U [table] parameters  Update a conntrack
> -E [table] [options]    Show events
> -F [table]              Flush table
> 
> Patch attached & inlined (for easy review):

Applied. Thanks.

> 5. Missing information in help/man about possibility of using "-i".

Added -i to the manpage. Thanks for the bug report.

-- 
Pablo
