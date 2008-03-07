From: pedro noticioso <cucnews@yahoo.com>
Subject: transparent proxy per client
Date: Thu, 6 Mar 2008 17:09:32 -0800 (PST)
Message-ID: <68258.97746.qm@web55406.mail.re4.yahoo.com>
References: <Pine.LNX.4.64.0803051446170.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web55406.mail.re4.yahoo.com ([206.190.58.200]:25166 "HELO
	web55406.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754117AbYCGBQO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:16:14 -0500
In-Reply-To: <Pine.LNX.4.64.0803051446170.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi there friends!

My objective is to be able to activate or deactivate
transparent proxy for some clients while leaving other
clients wide open to the net.

http://tldp.org/HOWTO/TransparentProxy-5.html

tells me how to send  the complete network to squid,
but I would like to only set a port range
10.0.0.1-10.0.0.100 to squid and leave por range
10.0.0.101-10.0.0.254 wide open.

So I tried this for most flexibility:


myIPS=3D"10.0..250 192.168.17.248 10.0.0.76"
for eachip in $myIPS
do
iptables -t nat -A PREROUTING -i $LAN_INTERFACE1 \
         -s $eachip -p tcp \
         --dport 80 -j REDIRECT --to-port 3128
done

I get no error message running my script, but I dont
see any extra proxy activity on the clients eather
while browsing the web with them, may I please get
some help?

thanks!

--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

>=20
> On Mar 5 2008 08:31, Oleg Petrov wrote:
> >
> >I'm working on kernel module used for network
> accounting and it's based
> >on amazing netfilter connection tracking code. But
> I lack some information
> >in nf_conn structure. Can you please advice what's
> preferable way of
> >getting such information:
> >
> >1) In/out interface indices.
> >More accurately, I'm interested in SNMP
> >interface indices to export accounting information
> but I hadn't seen
> >any interface stuff in conntrack code.
>=20
> Conntrack does not deal with interfaces=C2 =E2=80=94 that is
> a routing thing.
> It would be perfectly valid to send an SNMP query
> out on eth0,
> and receive the reply on eth1, while the re-reply
> goes out on eth2...
>=20
> Hence conntrack only deals with <source address,
> destination address,
> other bits like port numbers or for example ESP SPI
> indexes> tuples.
> There is a dirty hack, which is skb->iif, but I
> would not rely on it.
>=20
> >2) TCP connection flags and IP ToS (Type of
> Service).
> >
> >If this is not implemented in conntrack, please
> describe me preferable
> >way for adding support of this into netfilter - and
> I'll do so.
>=20
> TOS is not part of the unique tuple to identify a
> connection,
> hence I do not think it should be used as such
> (though you are free
> to do so, but I tell you, the result may not work).
>=20
> Or you can=C2 =E2=80=94 but again it only makes sense for
> learning nfct=C2 =E2=80=94
> to force the same TOS bit on any connection (and if
> that is not
> the case, drop it.)
> --
> To unsubscribe from this list: send the line
> "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=20
> http://vger.kernel.org/majordomo-info.html
>=20



      _________________________________________________________________=
___________________
Never miss a thing.  Make Yahoo your home page.=20
http://www.yahoo.com/r/hs
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
