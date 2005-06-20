From: Steve Davies <davies147@gmail.com>
Subject: Re: [PATCH] SIP/SDP conntrack and NAT helper
Date: Mon, 20 Jun 2005 10:46:05 +0100
Message-ID: <5caa9b87050620024652114b0a@mail.gmail.com>
References: <1115493770.1949.9.camel@www.l-chr.com.ar>
Reply-To: Steve Davies <davies147@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
In-Reply-To: <1115493770.1949.9.camel@www.l-chr.com.ar>
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

On 5/7/05, Christian Hentschel <chentschel@arnet.com.ar> wrote:
> Hi,
>         these patches adds conntrack and NAT support for SIP/SDP protocol=
.
> Currently it only support audio sessions, and it's status is "works for
> me!"
>=20
> There's some work to be done, but some help with testing, or some
> feedback about this would be great meanwhile.
>=20
> These patches are against lastest revision of pmo-ng, and only works in
> new > 2.6.11 nat framework.
>=20

If it is still of interest, I have found a couple of cases where the
current sip_conntrack appears to fall short. I am still using the
2.6.10 kernel, and the older sip_conntrack code, but I compared it to
the latest version I could find of sip_copnntrack for 2.6.11, and the
same should apply.

In our network, we use SNOM 190 phones. When they register, they
negotiate to listen on a dynamic port number (NOT 5060) - The
conntrack code is only looking for packets with a SOURCE port of 5060,
so when the SNOM 190 initiates the INVITE, the destination port is
5060, but the source port is not. Of course conntrack does not see
this, and the RTP packets  are not allowed.

This currently only seems to happen with either an IAX forwarded call,
or a transferred call. I am still experimenting.

I am sure there is an "elegant" way to cater for this, but my kludged
attempts were a bit of a failure :)

Kind regards,
Steve
