From: Tim Gardner <timg@tpi.com>
Subject: Re: 2.4 SNAT fails randomly
Date: Tue, 18 Nov 2003 08:35:09 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311180835.09794.timg@tpi.com>
References: <200311151103.47454.timg@tpi.com> <20031116095206.GA32471@balabit.hu> <200311160953.51722.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <200311160953.51722.timg@tpi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've been thinking more about this scenario. When a standard distribution=
 like=20
SuSE-9.0 boots, the interfaces are  IFF_UP sometime before firewall rules=
 are=20
installed. This is particularly a problem in the case of a NAT router. Is=
=20
there any way to flush /proc/net/ip_conntrack to make sure that you get r=
id=20
of entries that were established between the time the interfaces were bro=
ught=20
up and the time the rules were installed? Removing the ip_conntrack modul=
es=20
seems kind of brute force, and does not work on kernels where ip_conntrac=
k is=20
not a module.

rtg

On Sunday 16 November 2003 09:53, Tim Gardner wrote:
> Balazs,
>
> You are exactly correct. I swapped the interface creation statements wi=
th
> the iptables rules so that the rules were in place before any packets c=
ould
> be received from the interior net. In fact, I had to make sure that the
> interior net interface was down. Otherwise it would make an entry in
> ip_conntrack, regardless of the IP address of the interior interface.
>
> Thanks for your help.
>
> rtg
>
> On Sunday 16 November 2003 02:52, Balazs Scheidler wrote:
> > NAT mappings are established for NEW connections only, isn't it possi=
ble
> > that your client sent an NTP request while your rule was not yet
> > established? This means that it is entered the CONNTRACK table withou=
t
> > the NAT manip and anything that comes later is not NATed as it is not=
 a
> > fresh CONNTRACK.
> >
> > Try filtering this traffic for 180secs and see it disappear from
> > /proc/net/ip_conntrack, then remove the filtering and check whether i=
t
> > traversed the  nat/POSTROUTING chain.

--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
