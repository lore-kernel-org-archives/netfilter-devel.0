From: Tim Gardner <timg@tpi.com>
Subject: Re: 2.4 SNAT fails randomly
Date: Sun, 16 Nov 2003 09:53:51 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311160953.51722.timg@tpi.com>
References: <200311151103.47454.timg@tpi.com> <20031116095206.GA32471@balabit.hu>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20031116095206.GA32471@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Balazs,

You are exactly correct. I swapped the interface creation statements with=
 the=20
iptables rules so that the rules were in place before any packets could b=
e=20
received from the interior net. In fact, I had to make sure that the inte=
rior=20
net interface was down. Otherwise it would make an entry in ip_conntrack,=
=20
regardless of the IP address of the interior interface.

Thanks for your help.

rtg

On Sunday 16 November 2003 02:52, Balazs Scheidler wrote:
>
> NAT mappings are established for NEW connections only, isn't it possibl=
e
> that your client sent an NTP request while your rule was not yet
> established? This means that it is entered the CONNTRACK table without =
the
> NAT manip and anything that comes later is not NATed as it is not a fre=
sh
> CONNTRACK.
>
> Try filtering this traffic for 180secs and see it disappear from
> /proc/net/ip_conntrack, then remove the filtering and check whether it
> traversed the  nat/POSTROUTING chain.

--=20
Tim Gardner - timg@tpi.com 406-443-5357
TriplePoint, Inc. - http://www.tpi.com
PGP: http://www.tpi.com/PGP/Tim.txt
