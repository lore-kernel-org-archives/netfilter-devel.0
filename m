From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] strange iptables statistics =(
Date: Tue, 15 Jun 2004 22:32:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CF5CE5.8080601@trash.net>
References: <000901c45225$6166ef60$26a8a8c0@trondcyber>
Reply-To: Renat Araslanow <tr0nd@bitel.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Renat Araslanow <tr0nd@bitel.ru>
In-Reply-To: <000901c45225$6166ef60$26a8a8c0@trondcyber>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Tbis belongs on netfilter-devel ..

Renat Araslanow wrote:
> hi!
> 
> subj in iptables 1.26 on redhat 7.3 ipv4
> 
> as u can see in "ufanets_out" chain there is 328 packets, but in chain
> "by_protocol_out" we see only 1 udp packet. i have one more ip range - and
> its reported ok. can u explain me this please? thanks in advance.
> 
> PS% i dont see that similair bug is fixed in more modern versions of
> iptables - so don't yet upgraded.
> 
> Chain OUTPUT (policy ACCEPT 3887 packets, 2621833 bytes)
>     pkts      bytes target     prot opt in     out     source
> destination
>     9176  4237257            all  --  *      *       0.0.0.0/0
> 0.0.0.0/0
>      156    18884 ACCEPT     all  --  *      *       0.0.0.0/0
> 213.24.120.72
>     5133  1596540 ACCEPT     all  --  *      *       0.0.0.0/0
> 127.0.0.1
>     3887  2621833 accounting_out  all  --  *      *       0.0.0.0/0
> 0.0.0.0/0
> 
> Chain accounting_out (1 references)
>     pkts      bytes target     prot opt in     out     source
> destination
>     3887  2621833 ufanet_nets_out  all  --  *      *       0.0.0.0/0
> 0.0.0.0/0
>     3887  2621833 by_protocol_out  all  --  *      *       0.0.0.0/0
> 0.0.0.0/0
> 
> Chain ufanet_nets_out (1 references)
>     pkts      bytes target     prot opt in     out     source
> destination
>      328    15649 RETURN     all  --  *      *       0.0.0.0/0
> 213.24.120.70
> 
> Chain by_protocol_out (1 references)
>     pkts      bytes target     prot opt in     out     source
> destination
>      134    10790            udp  --  *      *       0.0.0.0/0
> 0.0.0.0/0
>        4      660            icmp --  *      *       0.0.0.0/0
> 0.0.0.0/0
>     3049  2573511            tcp  --  *      *       0.0.0.0/0
> 0.0.0.0/0          multiport sports 80,8080,443
>        0        0            tcp  --  *      *       0.0.0.0/0
> 0.0.0.0/0          tcp spts:20:21
>       75     5883            tcp  --  *      *       0.0.0.0/0
> 0.0.0.0/0          multiport dports 110,25
> 
>        1      121            udp  --  *      *       0.0.0.0/0
> 213.24.120.70
>        0        0            icmp --  *      *       0.0.0.0/0
> 213.24.120.70
>        0        0 RETURN     tcp  --  *      *       0.0.0.0/0
> 213.24.120.70      multiport sports 80,8080,443
>        0        0 RETURN     tcp  --  *      *       0.0.0.0/0
> 213.24.120.70      tcp spts:20:21
>        0        0 RETURN     tcp  --  *      *       0.0.0.0/0
> 213.24.120.70      multiport dports 110,25
> 
> 
