From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Thu, 16 Feb 2006 21:29:31 +0100
Message-ID: <43F4E0AB.5080806@trash.net>
References: <BAY103-F938A1F933DD48F94C262EB2FB0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F938A1F933DD48F94C262EB2FB0@phx.gbl>
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
> I'm running openswan 2.4.5 with 2.6.16-rc3-git6 on
> slackware 10.2 and I have a very strange problem.
> I don't know if this is the desired behaviour or a
> bug. I'm using iptables 1.3.5
> With the following rules I was running ipsec
> successfully with linux 2.6.15.1 to all our ipsec
> gateway. After I have upgraded to 2.6.16-rc3-git6
> I'm able to run ipsec only to venice_gateway.
> 
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> ACCEPT     all  --  venice_gateway       0.0.0.0/0
> ACCEPT     all  --  127.0.0.1            127.0.0.1
> ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state
> RELATED,ESTABLISHED
> red-me     all  --  0.0.0.0/0            0.0.0.0/0
> 
> Chain red-me (1 references)
> pkts bytes target     prot opt in     out     source              
> destination
>    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0           
> 0.0.0.0/0           icmp type 3
>    0     0 ACCEPT     esp  --  *      *       0.0.0.0/0           
> 0.0.0.0/0
>    0     0 ACCEPT     udp  --  *      *       0.0.0.0/0           
> 0.0.0.0/0           multiport dports 500,4500
> 
> For now, I have workarounded the problem adding a rule for every ipsec
> gateway,
> but this is a problem for mobile users.

2.6.16-rc includes patches for proper netfilter IPsec handling.
Packets will now go through the chains once in plain text and
once encrypted, so you need to adapt your ruleset. There is a
new "policy" match, which allows to match on packets from/to
IPsec tunnels, with that it should be relatively easy to create
rules for your roadwarriors.
