From: Ivan Mitev <imitev@obs.bg>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Sat, 24 Apr 2004 13:17:49 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040424101748.GB23401@obs.bg>
References: <20040415212034.GE7611@obs.bg> <407FE99D.6010100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <407FE99D.6010100@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi !

i tried to use the ipsec policy for a transport mode, AH+ESP, but i don't
manage to get it working (ie pkts are not matched by the ipsec policy rule)
however AH or ESP alone work fine.

btw, maybe no one uses AH + ESP, but that's only a test...

setup:

 --------                           --------
 | rtr1 | 2.10 --- "inet" ---- 3.10 | rtr2 |
 -------- eth1                 eth1 --------

setkey on rtr1:

spdadd 172.16.3.10 172.16.2.10 any -P out ipsec
        esp/transport//require
        ah/transport//require;

spdadd 172.16.2.10 172.16.3.10 any -P in ipsec
        esp/transport//require
        ah/transport//require;

assuming OUTPUT is wide open, the following rules are not matched by 
incoming pkts from rtr2 (i do a ping from rtr2 to rtr1)

iptables -A INPUT  -m policy --dir in --pol ipsec -j ACCEPT

iptables -A INPUT  -m policy --dir in --proto ah --pol ipsec -j ACCEPT
iptables -A INPUT  -m policy --dir in --proto esp --pol ipsec -j ACCEPT

tcpdump on rtr1 eth1:

1:28:05.801812 IP 172.16.3.10 > 172.16.2.10: AH(spi=0x08aac272,seq=0x2): ESP(spi=0x0cf46759,seq=0x2)

as soon as i "free" INPUT, packets begin to flow; packets also flow when
i set the following rule, so it seems that AH+ESP is not reconized as ipsec:
iptables -A INPUT  -m policy --dir in --pol none -j ACCEPT 

a word about other tests:
 - multiple (>10) concurrent tunnels work fine; once some appropriate user
   chains are set up, the ipsec policy match is very flexible, and provides
   more control than with the ipsec+ devices of freeswan ; cool!
 - i didn't have time yet to test that mangle works fine (eg. test that packets
   keep their fwmark while being encrypted/decrypted, and that seeing the 
   packet in both its encrypted and decrypted form doesn't mess up with tc).
 - SNAT is working well with tunnel mode; eg when the hosts behind rtr1 are
   s-natted with rtr1's private ip; i didn't test very complicated S/DNAT
   setups though.

ivan



On Fri, Apr 16, 2004 at 04:11:41PM +0200, Patrick McHardy wrote:
> Ivan Mitev wrote:
> 
> > [...]
> >
> >anwyway, with the comment/uncomment of the 2 includes, plus with some 
> >manual
> >tweaks for the policy patch, i got everything running.
> 
> I'm going to look into these problems, thanks.
> 
> >now, the real testing, so here is the setup (very basic for now): 
> >
> >all nets are 172.16.x.x/24
> >
> >               --------                           --------
> > .1.0 --- 1.10 | rtr1 | 2.10 --- "inet" ---- 3.10 | rtr2 | 4.10 --- .4.0
> >          eth0 -------- eth1                 eth1 -------- eth0
> >
> >
> >rtr1 is the 2.6 ipsec gw where i test the new ipsec patches
> >
> >"inet" is in fact another router where i can tcpdump to
> >check that i only have ESP and/or AH packets between 2.10 and 3.10
> >
> >i only have a tunnel for .1.0 <-> .4.0 networks, and no transport mode.
> >
> >after a bit of tests, i saw that the ipsec match doesn't work when i 
> >specify --tunnet-dst/src; otherwise it works very well, at least for this 
> >basic setup.
> >
> >so, for example that rule works:
> >
> >iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec 
> >--strict --proto esp --mode tunnel -j ACCEPT
> >
> >while these don't:
> >
> >iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec 
> >--strict --proto esp --mode tunnel --tunnel-dst 172.16.4.0/24 -j ACCEPT
> >
> >or
> >
> >iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec 
> >--strict --proto esp --mode tunnel --tunnel-src 172.16.1.0/24 -j ACCEPT
> >
> >or 
> >
> >iptables -A FORWARD -i eth0 -o eth1 -m policy --dir out --pol ipsec 
> >--strict --proto esp --mode tunnel --tunnel-src 172.16.1.0/24 --tunnel-dst 
> >172.16.4.0/24 -j ACCEPT
> 
> From your diagram above I'd say that you need
> --tunnel-src x.y.2.10 --tunnel-dst x.y.3.10. tunnel-src
> and tunnel-dst match the ipsec-tunnel peers, not the
> addresses of the encapsulated packets.
> 
> >that's it for now; later i'll try to migrate/test a part of a (really) 
> >more complex setup, with lots of iptables and tc rules (so i expect some 
> >problems where the packets are seen twice, in their encrypted/de-encrypted 
> >form). i also have some user-space apps that use ip_queue, so i'll see 
> >if they'll be broken.
> 
> I'm looking forward to your tests.
> 
> >if some of you are interested in more tests for the transport mode, i can
> >investigate that too...
> 
> Sure, anything helps. Thanks for your help ;)
> 
> Regards,
> Patrick
> 
> >
> >regards,
> >ivan
> >
> 

-- 
