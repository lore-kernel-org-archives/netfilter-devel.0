From: Andy Furniss <andy.furniss@dsl.pipex.com>
Subject: Re: How to balance OUTBOUND traffic by packet if..
Date: Fri, 14 Jan 2005 15:10:02 +0000
Message-ID: <41E7E0CA.5090509@dsl.pipex.com>
References: <1483.192.168.1.2.1105403313@maild.mine.nu>	<41E5E91C.6050606@dsl.pipex.com> <41E6694A.2020203@dsl.pipex.com> <41E72982.5000205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LARTC@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <lartc-admin@mailman.ds9a.nl>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41E72982.5000205@trash.net>
Sender: lartc-admin@mailman.ds9a.nl
Errors-To: lartc-admin@mailman.ds9a.nl
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Subscribe: <http://mailman.ds9a.nl/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
List-Unsubscribe: <http://mailman.ds9a.nl/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Andy Furniss wrote:
> 
>> Seems still broken.
>>
>> I built vanilla(apart from nth) 2.6.10, new iptables 1.2.11 + 
>> pom-200400621 with runme extra only said y to nth.
>>
>> I see -
>>
>> Chain OUTPUT (policy ACCEPT 817 packets, 103K bytes)
>>  pkts bytes target     prot opt in     out     source destination
>>    15  1260 MARK       all  --  *      eth0    0.0.0.0/0 
>> 0.0.0.0/0           every 2th packet #0 MARK set 0x1
>>    15  1260 MARK       all  --  *      eth0    0.0.0.0/0 
>> 0.0.0.0/0           every 2th packet #1 MARK set 0x2
>>
>> Chain POSTROUTING (policy ACCEPT 817 packets, 103K bytes)
>>  pkts bytes target     prot opt in     out     source destination
>>     0     0            all  --  *      eth0    0.0.0.0/0 
>> 0.0.0.0/0           MARK match 0x1
>>    15  1260            all  --  *      eth0    0.0.0.0/0 
>> 0.0.0.0/0           MARK match 0x2
>> [root@amd /home/andy]# cat ./nth-test
>> iptables -t mangle -A OUTPUT -o eth0 -m nth --counter 1 --every 2 
>> --packet 0 -j MARK --set-mark 1
>> iptables -t mangle -A OUTPUT -o eth0 -m nth --counter 1 --every 2 
>> --packet 1 -j MARK --set-mark 2
>> iptables -t mangle -A POSTROUTING -o eth0 -m mark --mark 1
>> iptables -t mangle -A POSTROUTING -o eth0 -m mark --mark 2
>>
>> Any Ideas anyone?
> 
> 
> 
> Try adding "-m mark --mark X -j RETURN" rules after the MARK rules. The 
> MARK
> target is non-terminal, so you are overwriting the mark in the second rule.
> Alternatively you can use "--start 1" in the one of the nth matches.

Thanks Patrick - I assumed that with the same counter and packet 0/1 
that nth would only actually match alternate packets (start didn't work).

So this works -

iptables -t mangle -A OUTPUT -o eth0 -m nth --counter 1 --every 2 
--packet 0 -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -o eth0 -m mark --mark 1 -j RETURN
iptables -t mangle -A OUTPUT -o eth0 -m nth --counter 1 --every 2 
--packet 1 -j MARK --set-mark 2
iptables -t mangle -A OUTPUT -o eth0 -m mark --mark 2 -j RETURN

but is over complicated really - Why I didn't do it like below in the 
first place I don't know <slaps self>

iptables -t mangle -A OUTPUT -o eth0 -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -o eth0 -m nth --every 2  -j MARK --set-mark 2

Andy.

PS had to remove junk@maild.mine.nu from CC as my ISP server threw a 
domain not found - can someone else CC him please.



_______________________________________________
LARTC mailing list / LARTC@mailman.ds9a.nl
http://mailman.ds9a.nl/mailman/listinfo/lartc HOWTO: http://lartc.org/
