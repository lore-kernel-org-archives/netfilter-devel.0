From: Mark Warren <mwarren@genuity.net>
Subject: Re: DISREGARD - unclean module handling of UDP packets with no checksum
 broken?
Date: Thu, 19 Sep 2002 21:09:52 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3D8A7560.6030407@genuity.net>
References: <3D8A7427.2010900@genuity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

d'oh!  My appologies, I spoke too soon.  I found the patch submission 
for this problem in the list archives.

Sorry!
- Mark Warren

Mark Warren wrote:
> Hi,
>   It seems that the unclean module's handling of UDP packets with no 
> checksum may be broken.  Per RFC768, UDP packets are not required to use 
> checksums.  In the case that they don't, the checksum field of the UDP 
> header should contain all 0s.  The following ipt_unclean.c code causes 
> such packets to be silently (unless you configure your firewall to log 
> matches to this rule) discarded:
> 
>         /* Bad checksum?  Don't print, just say it's unclean. */
>         /* FIXME: SRC ROUTE packets won't match checksum --RR */
>         if (!more_frags &&
>             !embedded &&
>             csum_tcpudp_magic(iph->saddr, iph->daddr, datalen,
>                               IPPROTO_UDP,
>                               csum_partial((char *)udph, datalen, 0))
>               != 0)
> 
>                 return 0;
> 
>   I'm wondering if this is desired behavior or if this is a bug.  I have 
> come across a problem where legitimate and well formed packets are being 
> dropped by this code.  Some Cisco IOS versions (particularly older Cisco 
> DistributedDirector IOS) don't use checksums in UDP packets.  Some 
> features allow you to turn on checksums, others don't.  The Director 
> feature doesn't.  I'm not sure how many other real-world applications 
> behave this way.
> 
> Thanks!
> - Mark Warren
> 
> ps: i appologize if this has been discussed before.  i searched through 
> the list archives, but was unable to find anything relevant to this 
> subject.
> 
> -- Analysis --
> #
> # Packet dump of DNS packet from a DistributedDirector:
> #
> <snip>
> IP:   ----- IP Header -----
> IP:
> IP:   Version = 4
> IP:   Header length = 20 bytes
> IP:   Type of service = 0x00
> IP:         xxx. .... = 0 (precedence)
> IP:         ...0 .... = normal delay
> IP:         .... 0... = normal throughput
> IP:         .... .0.. = normal reliability
> IP:   Total length = 74 bytes
> IP:   Identification = 20292
> IP:   Flags = 0x0
> IP:         .0.. .... = may fragment
> IP:         ..0. .... = last fragment
> IP:   Fragment offset = 0 bytes
> IP:   Time to live = 245 seconds/hops
> IP:   Protocol = 17 (UDP)
> IP:   Header checksum = e488
> IP:   Source address = 205.181.115.167, 205.181.115.167
> IP:   Destination address = 171.78.165.42, 171.78.165.42
> IP:   No options
> IP:
> UDP:  ----- UDP Header -----
> UDP:
> UDP:  Source port = 53
> UDP:  Destination port = 34145
> UDP:  Length = 54
> UDP:  Checksum = 0000 (no checksum)
> UDP:
> DNS:  ----- DNS Header -----
> <snip>
> 
> #
> # rules to test
> # 205.181.115.167 is a DistributedDirector that runs older code that
> # does not use UDP checksums.
> # 4.2.35.31 is a DistributedDirector that runs newer code that does
> #
> iptables -N MWUNCLEAN
> iptables -A INPUT -i eth1 -p udp -s 205.181.115.167 -m unclean \
>          -j MWUNCLEAN
> iptables -A INPUT -i eth1 -p udp -s 4.2.35.31 -m unclean \
>          -j MWUNCLEAN
> iptables -A MWUNCLEAN -j LOG --log-level info \
>          --log-prefix "MWUNCLEAN -- DROP " --log-tcp-options \
>          --log-ip-options
> iptables -A MWUNCLEAN -j DROP
> 
> #
> # I modified the unclean module source to log the fact that it was
> # dropping packets due to this code, and include the results of
> # csum_tcpudp_magic().
> #
> <snip>
> #define limpk(format, args...)                               \
> do {                                                         \
>   if (net_ratelimit())                                       \
>     printk(KERN_EMERG "ipt_unclean: %s" format,              \
>            embedded ? "(embedded packet) " : "" , ## args);  \
> } while(0)
> <snip>
>     /* Bad checksum?  Don't print, just say it's unclean. */
>     /* FIXME: SRC ROUTE packets won't match checksum --RR */
>     if (!more_frags && !embedded &&
>         csum_tcpudp_magic(iph->saddr, iph->daddr, datalen, IPPROTO_UDP,
>                           csum_partial((char *)udph, datalen, 0)) != 0)
>     {
> 
>       limpk("UDP checksum failed (0x%x)\n",
>             csum_tcpudp_magic(iph->saddr, iph->daddr, datalen,
>             IPPROTO_UDP, csum_partial((char *)udph, datalen, 0)));
> 
>             return 0;
>     }
> <snip>
> 
> #
> # Testing against my kernel/module modifications
> #
> [root@forty-two rc.d]# dig @205.181.115.167 a.vaid.host.name A +norecurs
> 
> ; <<>> DiG 9.2.1 <<>> @205.181.115.167 a.valid.host.name A +norecurs
> ;; global options:  printcmd
> ;; connection timed out; no servers could be reached
> 
> [root@forty-two netfilter]# dig @4.2.35.31 a.valid.host.name A +norecurs
> 
> ; <<>> DiG 9.2.1 <<>> @4.2.35.31 a.valid.host.name A +norecurs
> ;; global options:  printcmd
> ;; Got answer:
> ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21791
> ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
> 
> ;; QUESTION SECTION:
> ;a.valid.host.name.             IN      A
> 
> ;; ANSWER SECTION:
> a.valid.host.name.      60      IN      A       10.0.0.1
> 
> ;; Query time: 813 msec
> ;; SERVER: 4.2.35.31#53(4.2.35.31)
> ;; WHEN: Wed Sep 18 11:55:08 2002
> ;; MSG SIZE  rcvd: 50
> 
> #
> # Yielded the following logs
> #
> [root@forty-two log]# grep 205.18 messages
> Sep 18 10:31:48 forty-two kernel: MWUNCLEAN -- DROP IN=eth1 OUT= 
> MAC=00:10:5a:0c:60:1f:00:30:19:72:b5:8c:08:00 SRC=205.181.115.167 DST=2
> 4.128.239.65 LEN=74 TOS=0x00 PREC=0x00 TTL=240 ID=71 PROTO=UDP SPT=53 
> DPT=32805 LEN=54
> Sep 18 15:47:24 forty-two kernel: ipt_unclean: UDP checksum failed (0x909b)
> 
