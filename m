From: Marian Stagarescu <marian@ti.com>
Subject: Re: snat and ICMP question
Date: Wed, 9 Oct 2002 09:34:03 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200210090934.03315.marian@ti.com>
References: <3DA30D48.3EA0E56E@netcelo.com> <3DA400B9.390A17F7@netcelo.com> <3DA4100B.79866BC0@netcelo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ciaran Deignan <ciaran.deignan@netcelo.com>,
   netfilter-devel@lists.netfilter.org,
   Matthieu Marc <matthieu.marc@netcelo.com>
In-Reply-To: <3DA4100B.79866BC0@netcelo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

for a quick test you can try to masquerade all and see if the error persi=
sts:

iptables -t nat -A POSTROUTING -o outgoing-interface -j MASQUERADE.

can you post the icmp error message ?

an ICMP does have an outter ip hdr and an inner ip dhr
the inner ip hdr is the ip hdr of the dgram that caused the error,=20
hence should be the web server ip.
the outer ip hdr should be NATed address if you do the above masquerading=
=2E

marian



On Wednesday 09 October 2002 07:16 am, Ciaran Deignan wrote:
> > > > iptables -t mangle -A PREROUTING --in-interface ipsec+ \
> > > >                         -j MARK --set-mark 1
> > > > iptables -t nat -A POSTROUTING -m mark --mark 1 \
> > > >                                 -j MASQUERADE
> >
> > config. Actually, the web server is on the private interface.
> >
> > The ICMP error message contains the real address of the
> > remote user. Do you think I should mark ICMP messages
> > on the OUTPUT chain? I must try that...
>
> I tried adding the following rule, but that didn't change
> anything:
>
> =09iptables -t mangle -A OUTPUT -p ICMP -j MARK --set-mark 1
>
> Is there any way I could cause the ICMP error to be
> generated before the packet is de-nated?
>
> Ciaran
