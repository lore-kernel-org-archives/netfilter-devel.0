From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Sat, 24 Apr 2004 13:14:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408A4C2F.3050209@trash.net>
References: <20040415212034.GE7611@obs.bg> <407FE99D.6010100@trash.net> <20040424101748.GB23401@obs.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ivan Mitev <imitev@obs.bg>
In-Reply-To: <20040424101748.GB23401@obs.bg>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Ivan,

Ivan Mitev wrote:
> hi !
> 
> i tried to use the ipsec policy for a transport mode, AH+ESP, but i don't
> manage to get it working (ie pkts are not matched by the ipsec policy rule)
> however AH or ESP alone work fine.
> 
> btw, maybe no one uses AH + ESP, but that's only a test...
> 
> setup:
> 
>  --------                           --------
>  | rtr1 | 2.10 --- "inet" ---- 3.10 | rtr2 |
>  -------- eth1                 eth1 --------
> 
> setkey on rtr1:
> 
> spdadd 172.16.3.10 172.16.2.10 any -P out ipsec
>         esp/transport//require
>         ah/transport//require;
> 
> spdadd 172.16.2.10 172.16.3.10 any -P in ipsec
>         esp/transport//require
>         ah/transport//require;
> 
> assuming OUTPUT is wide open, the following rules are not matched by 
> incoming pkts from rtr2 (i do a ping from rtr2 to rtr1)
> 
> iptables -A INPUT  -m policy --dir in --pol ipsec -j ACCEPT
> 
> iptables -A INPUT  -m policy --dir in --proto ah --pol ipsec -j ACCEPT
> iptables -A INPUT  -m policy --dir in --proto esp --pol ipsec -j ACCEPT
> 
> tcpdump on rtr1 eth1:
> 
> 1:28:05.801812 IP 172.16.3.10 > 172.16.2.10: AH(spi=0x08aac272,seq=0x2): ESP(spi=0x0cf46759,seq=0x2)
> 
> as soon as i "free" INPUT, packets begin to flow; packets also flow when
> i set the following rule, so it seems that AH+ESP is not reconized as ipsec:
> iptables -A INPUT  -m policy --dir in --pol none -j ACCEPT 

Did you have rules to accept the encrypted packets ? The policy match
only matches the decapsulated packets, so you need to accept the outer
protocol using the protocol match. AH+ESP works fine with this setup:

setkey:
spdadd 192.168.0.23/32 0.0.0.0/0 any
         -P out ipsec
         esp/tunnel/0.0.0.0-192.168.0.1/require
         ah/transport//require;

spdadd 0.0.0.0/0 192.168.0.23/32 any
         -P in ipsec
         esp/tunnel/192.168.0.1-0.0.0.0/require
         ah/transport//require;

policy match:
iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto esp
  --mode tunnel --tunnel-src 192.168.0.1 --tunnel-dst 192.168.0.23 --next
  --proto ah --mode transport

iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp
  --mode tunnel --tunnel-src 192.168.0.23 --tunnel-dst 192.168.0.1 --next
  --proto ah  --mode transport

All packets are accepted, the rules are just there for counting.
I have not tried nested transport-mode SAs yet, but I will try after
recompling the kernel.

> a word about other tests:
>  - multiple (>10) concurrent tunnels work fine; once some appropriate user
>    chains are set up, the ipsec policy match is very flexible, and provides
>    more control than with the ipsec+ devices of freeswan ; cool!
>  - i didn't have time yet to test that mangle works fine (eg. test that packets
>    keep their fwmark while being encrypted/decrypted, and that seeing the 
>    packet in both its encrypted and decrypted form doesn't mess up with tc).
>  - SNAT is working well with tunnel mode; eg when the hosts behind rtr1 are
>    s-natted with rtr1's private ip; i didn't test very complicated S/DNAT
>    setups though.

Thanks for your testing.

Regards
Patrick

> 
> ivan
> 
