From: Robert de Bath <list-netfilter@debath.co.uk>
Subject: Re: Iptables 1.3.1 still not very fast.
Date: Sat, 2 Apr 2005 10:27:08 +0100 (BST)
Message-ID: <ade359ba902d15c6@mayday.cix.co.uk>
References: <89b63d049739b257@mayday.cix.co.uk>
	<20050402124038.0201.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050402124038.0201.LARK@linux.net.cn>
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

On Sat, 2 Apr 2005, Wang Jian wrote:

> Hi Robert,
>
> It seems that your problem can be solved by using 'set' match. I didn't
> use 'set' match, so I am not very sure. 'set' match is in pom-ng::base.

Okay, I've had a quick look at ipset and I think it could be made to work.
It appears that it can work in two modes that are useful here, ip-address
and net-address.

In ip-address mode each individual address has to be added to the hash
table for the example set from 'blocklist.org' this is around 600000000
addresses ... I do not have 2Gb of ram (minimum!) to, er, use on a hash
table!

NB: Yes that address list blacklists about 14% of the ipv4 space, I was
     looking for an evil example!

In net-address mode an ip+mask is converted into a single 32 bit value and
it can store different netmasks (despite the manpage).  This is okay if
you just want just networks but it cannot represent single IPs.  It would
still be necessary to convert the ip ranges to ip+mask notation though.

So you actually need two hashtables for the example 'blacklist' one in
each mode.  For an IP packet a single lookup is needed on the ip-address
hash but upto 30 lookups would be needed on the net-address hash.

Now my tree layout would result in about 20-40 rules scanned for a
single packet for 'the evil example'.

> For your situation, to generate so many rules to just match on source
> address is not efficient. In natural language, it is
>
>  "Is this source address in a blacklist?"
>
> and should be implemented this way as
>
>  "Is this source address in a blacklist (hash table)?"
>
> It has only one rule. And then, you can manipulate this hash table.
> (IMHO, the hash table involved is simple and fast)

... I would _hope_ the hashtable is faster ... it _should_ be ...
but with those complex hash algorithms I'm not sure.

If you're talking about efficency in terms of how easy it is to use
it's like this, load or reload:

$ iptrange -N dshield -j LOGnDROP -rt dshield.org.txt
... no waiting for 1000 ranges ...
$ 
$ iptrange -N blacklist -j LOGnDROP -rt blacklist.org.*.txt
... wait 5 minutes for 50000 ranges ...
$

In terms of memory, I definitly agree ipset would be better, at 4 bytes
per ip or 4 bytes per ip+mask it's very good even after the hash table
being only xx% populated. Using lots of iptables rules wastes a large
part of the structure that defines each rule.

But the real plus of iptrange is that it works with any kernel 2.4+ no
patches.

So _I_ still see a place for this little program at least until ipset
gets into the mainstream kernel. I just wish it didn't take O(n^2)
time to load the rules.

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                        <http://www.cix.co.uk/~mayday>
