From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip_conntrack cleanup on reconnection?
Date: Sun, 11 Jul 2004 04:06:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407110403400.24922-100000@filer.marasystems.com>
References: <40F00D16.9040109@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Herve Eychenne <rv@wallfire.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40F00D16.9040109@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 10 Jul 2004, Pablo Neira wrote:

> If I think that I observed a similar behaviour in 2.6, but using 
> DNAT/SNAT targets instead of MASQUERADE. Well, actually I'm not sure if 
> this exactly what you mean.

Only MASQUERADE cleans entries on interface change. DNAT/SNAT assumes 
static networking.

> root@legba:/home/pablo# iptables -I POSTROUTING -t nat -j SNAT --to 
> 192.168.30.30
> root@legba:/home/pablo# telnet 192.168.0.44 80
> Trying 192.168.0.44... ^c
> root@legba:/home/pablo# cat /proc/net/ip_conntrack
> tcp      6 114 SYN_SENT src=192.168.0.3 dst=192.168.0.44 sport=32779 
> dport=80 [UNREPLIED] src=192.168.0.44 dst=192.168.30.30 sport=80 
> dport=32779 use=1
>                                           ^^^
> 
> root@legba:/home/pablo# iptables -D POSTROUTING -t nat -j SNAT --to 
> 192.168.30.30
> 
> root@legba:/home/pablo# telnet 192.168.0.44 80
> Trying 192.168.0.44...
> root@legba:/home/pablo# cat /proc/net/ip_conntrack
> tcp      6 2 SYN_SENT src=192.168.0.3 dst=192.168.0.44 sport=32779 
> dport=80 [UNREPLIED] src=192.168.0.44 dst=192.168.30.30 sport=80 
> dport=32779 use=1

This is the old entry created in your first attempt..

> tcp      6 106 SYN_SENT src=192.168.0.3 dst=192.168.0.44 sport=32780 
> dport=80 [UNREPLIED] src=192.168.0.44 dst=192.168.0.3 sport=80 
> dport=32780 use=1

And this is the new.



This is 100% how it should be.  Alreaty set up NAT sessions should not go 
away only because you delete thre NAT rule, but there won't be any new NAT 
sessions after the rule is deleted.

Regards
Henrik
