From: Damien Sandras <dsandras@seconix.com>
Subject: Re: GnomeMeeting STUN
Date: Thu, 25 Dec 2003 17:48:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1072370922.680.6.camel@golgoth01>
References: <1072260947.722.25.camel@golgoth01>
	 <20031224143851.GD941@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20031224143851.GD941@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mer 24/12/2003 =E0 15:38, Harald Welte a =E9crit :
> On Wed, Dec 24, 2003 at 11:16:14AM +0100, Damien Sandras wrote:
> > Hello Harald,
>=20
> Hi Damien.  I'm Cc'ing your email to netfilter-devel, since there might
> be other developers interested in a discussion about STUN.
>=20

That's indeed a nice clarification :)

[...]

> NAT didn't change at all between 2.4.x and 2.6.x, so there is no change
> related to gnomemeeting.
>=20
> I assume all we have to offer is ip_conntrack/nat_h323, which is in
> patch-o-matic but has been reported not to work with gnomemeeting (but
> with netmeeting) in the past ?  We'd be happy to receive any feedback
> you would have regarding that subject.
>=20

I will do my best. I already had sent some information to Joszef a long
time ago, but I think it was lost.=20

The problem with the conntrack approach is that we will also have to do
the same kind of connection tracker for the SIP protocol :(

Thanks for the answer,

> > Thank you,
> >  _      Damien Sandras
--=20
 _      Damien Sandras
(o-    =20
//\     It-Optics s.a.
v_/_    GnomeMeeting: http://www.gnomemeeting.org/
        FOSDEM 2004:  http://www.fosdem.org
        H.323 phone:  callto:ils.seconix.com/dsandras@seconix.com
