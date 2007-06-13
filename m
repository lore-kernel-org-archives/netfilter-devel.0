From: "=?ISO-8859-1?Q?Juan_Le=F3n?=" <debjuanca@gmail.com>
Subject: Re: Follow packets in rules
Date: Wed, 13 Jun 2007 11:43:17 -0400
Message-ID: <6bb85d880706130843n31d8c1a6i19a4b119c85131a1@mail.gmail.com>
References: <000001c7ad1c$9ccb09b0$1806380a@adidf.efs.sante.fr>
	<466FB176.7040306@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Fabrice Rafart" <fabrice.rafart@efs.sante.fr>,
	netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <466FB176.7040306@netfilter.org>
Content-Disposition: inline
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

Hi Fabrice,


2007/6/13, Pablo Neira Ayuso <pablo@netfilter.org>:
> Fabrice Rafart wrote:
> > I look for a tool to follow a packets into rules of netfilter.
> >
> > For example :
> >
> > # iptables-test -s 192.168.1.1 -d 192.168.2.1 -p tcp --dport 25
> > --> FORWARD line 1  : -p tcp --dport 25 -j SMTP
> > --> SMTP line 3     : -s 192.168.1.0/24 -j DROP
> >
> > This show me which rules matches the packet until the end.
> >
> > Does this exist ?

  You can try using iptables command line to know if the package
matchs with your rules.

In the example bellow you'll see something familiar.

 debian:~# iptables -nvL FORWARD
Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
 125     25  ACCEPT     0    --  *      *       192.168.132.25
192.126.132.56


Let's take a close look at this part.
 pkts bytes
  125     25


 Every time your rule matchs, you'll see the packages changes.

Use the line bellow to check it.

debian:~# watch -n 1 'iptables -nvL FORWARD'


> check nfsim: http://ozlabs.org/~jk/projects/nfsim/
>
> AFAIK, it's not actively maintained so probably you'll have to hack on
> it a bit.

As far as read, it's not longer maintained.


I hope this help.

Best Regards.

> --
> The dawn of the fourth age of Linux firewalling is coming; a time of
> great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
>
>
