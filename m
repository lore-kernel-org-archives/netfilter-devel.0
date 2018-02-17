From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Sat, 17 Feb 2018 21:10:15 +0100
Message-ID: <20180217201015.GA13493@breakpoint.cc>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc>
 <20180216161408.GA3776@breakpoint.cc>
 <20180216.173354.347842978561257782.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, daniel@iogearbox.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, alexei.starovoitov@gmail.com
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180216.173354.347842978561257782.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Florian Westphal <fw@strlen.de>
> Date: Fri, 16 Feb 2018 17:14:08 +0100
> 
> > Any particular reason why translating iptables rather than nftables
> > (it should be possible to monitor the nftables changes that are
> >  announced by kernel and act on those)?
> 
> As Daniel said, iptables is by far the most deployed of the two
> technologies.  Therefore it provides the largest environment for
> testing and coverage.

Right, but the approach of hooking old blob format comes with
lots of limitations that were meant to be resolved with a netlink based
interface which places kernel in a position to mediate all transactions
to the rule database (which isn't fixable with old setsockopt format).

As all programs call iptables(-restore) or variants translation can
be done in userspace to nftables so api spoken is nfnetlink.
Such a translator already exists and can handle some cases already:

nft flush ruleset
nft list ruleset | wc -l
0
xtables-compat-multi iptables -A INPUT -s 192.168.0.24 -j ACCEPT
xtables-compat-multi iptables -A INPUT -s 192.168.0.0/16 -p tcp --dport 22 -j ACCEPT
xtables-compat-multi iptables -A INPUT -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
xtables-compat-multi iptables -A INPUT -p icmp -j ACCEPT
xtables-compat-multi iptables -N REJECT_LOG
xtables-compat-multi iptables -A REJECT_LOG -i eth0 -p tcp --tcp-flags SYN,ACK SYN --dport 22:80 -m limit --limit 1/sec -j LOG --log-prefix "RejectTCPConnectReq"
xtables-compat-multi iptables -A REJECT_LOG -j DROP
xtables-compat-multi iptables -A INPUT -j REJECT_LOG

nft list ruleset
table ip filter {
        chain INPUT {
                type filter hook input priority 0; policy accept;
                ip saddr 192.168.0.24 counter packets 0 bytes 0 accept
                ip saddr 192.168.0.0/16 tcp dport 22 counter accept
                iifname "eth0" ct state related,established counter accept
                ip protocol icmp counter packets 0 bytes 0 accept
                counter packets 0 bytes 0 jump REJECT_LOG
        }

        chain FORWARD {
                type filter hook forward priority 0; policy accept;
        }

        chain OUTPUT {
                type filter hook output priority 0; policy accept;
        }

        chain REJECT_LOG {
                iifname "eth0" tcp dport 22-80 tcp flags & (syn | ack) == syn limit rate 1/second burst 5 packets counter packets 0 bytes 0 log prefix "RejectTCPConnectReq"
                counter packets 0 bytes 0 drop
        }
}

and, while 'iptables' rules were added, nft monitor in different terminal:
nft monitor
add table ip filter
add chain ip filter INPUT { type filter hook input priority 0; policy accept; }
add chain ip filter FORWARD { type filter hook forward priority 0; policy accept; }
add chain ip filter OUTPUT { type filter hook output priority 0; policy accept; }
add rule ip filter INPUT ip saddr 192.168.0.24 counter packets 0 bytes 0 accept
# new generation 9893 by process 7471 (xtables-compat-)
add rule ip filter INPUT ip saddr 192.168.0.0/16 tcp dport 22 counter accept
# new generation 9894 by process 7504 (xtables-compat-)
add rule ip filter INPUT iifname "eth0" ct state related,established counter accept
# new generation 9895 by process 7528 (xtables-compat-)
add rule ip filter INPUT ip protocol icmp counter packets 0 bytes 0 accept
# new generation 9896 by process 7542 (xtables-compat-)
add chain ip filter REJECT_LOG
# new generation 9897 by process 7595 (xtables-compat-)
add rule ip filter REJECT_LOG iifname "eth0" tcp dport 22-80 tcp flags & (syn | ack) == syn limit rate 1/second burst 5 packets counter packets 0 bytes 0 log prefix "RejectTCPConnectReq"
# new generation 9898 by process 7639 (xtables-compat-)
add rule ip filter REJECT_LOG counter packets 0 bytes 0 drop
# new generation 9899 by process 7657 (xtables-compat-)
add rule ip filter INPUT counter packets 0 bytes 0 jump REJECT_LOG
# new generation 9900 by process 7663 (xtables-compat-)

Now, does this work in all cases?

Unfortunately not -- this is still work-in-progress, so I would
not rm /sbin/iptables and replace it with a link to xtables-compat-multi just yet.

(f.e. nftables misses some selinux matches/targets for netlabel so we obviously
can't translate this, same for ipsec sa/policy matching -- but this isn't
impossible to resolve).

Hopefully this does show that at least some commonly used features work
and that we've come a long way to make seamless nftables transition happen.
