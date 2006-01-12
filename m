From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 05:07:28 +0100
Message-ID: <43C5D600.2020507@trash.net>
References: <BAY103-F18706C52D2ACDEFC5D91E6B2240@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F18706C52D2ACDEFC5D91E6B2240@phx.gbl>
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

Marco Berizzi wrote:
> Hello.
> I'm testing the new iptables policy match on a snapshot kernel 
> (2.6.15-git7).
> This is my simple network diagram:
> 
> eth1                  eth0                                     
> eth0                    eth1
> 10.1.2.0/24===172.16.1.247..[ipsec tunnel]..172.16.1.226===10.1.1.0/24
> -----2.6.15-git7 linux box-----                         
> --------2.4/KLIPS box----------
> 
> I have setup a simple ipsec tunnel between the two linux boxes. So far, 
> so good.
> I'm pinging from 10.1.2.1 (a system connected to the 10.1.2.0/24 net) to 
> 10.1.1.1
> (a system connected to the 10.1.1.0/24 net). This is iptables -L -v output:
> 
> root@Calimero:/tmp/RACOON# iptables -L -v
> Chain INPUT (policy ACCEPT 70672 packets, 15M bytes)
> pkts bytes target     prot opt in     out     source               
> destination
> 
> Chain FORWARD (policy DROP 0 packets, 0 bytes)
> pkts bytes target     prot opt in     out     source               
> destination
>   19  1140 ACCEPT     all  --  any    any     anywhere             
> anywhere            policy match dir out pol ipsec strict [0] [1] [2] 
> [3] mode tunnel tunnel-dst 10.1.1.0/24 tunnel-src 10.1.2.0/24
>    0     0 DROP       all  --  any    any     anywhere             
> anywhere            policy match dir in pol ipsec strict [0] [1] [2] [3] 
> mode tunnel tunnel-dst 10.1.2.0/24 tunnel-src 10.1.1.0/24

How did you add these rules? It looks like you used "--next" multiple
times without specifying a policy element ..
