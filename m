From: "William da Rocha Lima" <wrochal@linuxit.com.br>
Subject: Re: Error in rules DNAT
Date: Fri, 4 Jul 2003 10:23:30 +0000 (UTC)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001101c343ff$2d83ce00$0100000a@william>
References: <Pine.LNX.4.44.0306291601130.24424-100000@laptop1.agatha>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Oskar Andreasson" <blueflux@koffein.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
Date: Sun, 6 Jul 2003 17:42:48 -0300
List-Id: netfilter-devel.vger.kernel.org

It leaves me to be more direct, for that I understand the rule without - i
ethX does not connect the IP that requisite and yes gateway.
====================
William da Rocha Lima
wrochal@linuxit.com.br
www.linuxit.com.br

----- Original Message ----- 
From: "Oskar Andreasson" <blueflux@koffein.net>
To: "William da Rocha Lima" <wrochal@linuxit.com.br>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Sunday, June 29, 2003 11:03 AM
Subject: Re: Error in rules DNAT


> Hi William,
>
> Sorry to say this, but I must ask, what are you talking about?
>
> On Sat, 5 Jul 2003, William da Rocha Lima wrote:
>
> > Oskar Andreasson,
> >
> > Verifies that rule DNAT this incorrect one:
> > iptables - t nat - the PREROUTING - p tcp - d 15,45,23,67 -- dport 80 -
j
> > DNAT -- to-destination 192,168,1,1
> >
> > the correct one is:
> >
> > iptables - t nat - the PREROUTING - p tcp - i ethX - d 15,45,23,67 -- 
> > dport - 80 j DNAT -- to-destination 192,168,1,1
> >
> > being that ethX is entrance interface
> >
> > Articles write iam:
> >
http://www.linuxit.com.br/modules.php?name=Sections&op=viewarticle&artid=21
> >
> > bye,
> >
> > ====================
> > William da Rocha Lima
> > wrochal@linuxit.com.br
> > www.linuxit.com.br
> >
> >
> >
>
> -- 
> ----
> Oskar Andreasson
> http://www.frozentux.net
> http://iptables-tutorial.frozentux.net
> http://ipsysctl-tutorial.frozentux.net
> mailto:blueflux@koffein.net
>
>
>
>
>
