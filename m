From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Fri, 16 Apr 2004 16:11:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407FE99D.6010100@trash.net>
References: <20040415212034.GE7611@obs.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ivan Mitev <imitev@obs.bg>
In-Reply-To: <20040415212034.GE7611@obs.bg>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ivan Mitev wrote:

 > [...]
> 
> anwyway, with the comment/uncomment of the 2 includes, plus with some manual
> tweaks for the policy patch, i got everything running.

I'm going to look into these problems, thanks.

> now, the real testing, so here is the setup (very basic for now): 
> 
> all nets are 172.16.x.x/24
> 
>                --------                           --------
>  .1.0 --- 1.10 | rtr1 | 2.10 --- "inet" ---- 3.10 | rtr2 | 4.10 --- .4.0
>           eth0 -------- eth1                 eth1 -------- eth0
> 
> 
> rtr1 is the 2.6 ipsec gw where i test the new ipsec patches
> 
> "inet" is in fact another router where i can tcpdump to
> check that i only have ESP and/or AH packets between 2.10 and 3.10
> 
> i only have a tunnel for .1.0 <-> .4.0 networks, and no transport mode.
> 
> after a bit of tests, i saw that the ipsec match doesn't work when i specify 
> --tunnet-dst/src; otherwise it works very well, at least for this basic setup.
> 
> so, for example that rule works:
> 
> iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel -j ACCEPT
> 
> while these don't:
> 
> iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-dst 172.16.4.0/24 -j ACCEPT
> 
> or
> 
> iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-src 172.16.1.0/24 -j ACCEPT
> 
> or 
> 
> iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec --strict --proto esp --mode tunnel --tunnel-src 172.16.1.0/24 --tunnel-dst 172.16.4.0/24 -j ACCEPT

 From your diagram above I'd say that you need
--tunnel-src x.y.2.10 --tunnel-dst x.y.3.10. tunnel-src
and tunnel-dst match the ipsec-tunnel peers, not the
addresses of the encapsulated packets.

> that's it for now; later i'll try to migrate/test a part of a (really) 
> more complex setup, with lots of iptables and tc rules (so i expect some 
> problems where the packets are seen twice, in their encrypted/de-encrypted 
> form). i also have some user-space apps that use ip_queue, so i'll see 
> if they'll be broken.

I'm looking forward to your tests.

> if some of you are interested in more tests for the transport mode, i can
> investigate that too...

Sure, anything helps. Thanks for your help ;)

Regards,
Patrick

> 
> regards,
> ivan
> 
