From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: 03 Apr 2003 13:21:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049368914.25169.63.camel@tux.rsn.bth.se>
References: <20030403025151.GA1702@pc.ilinx>
	 <1049364942.25148.60.camel@tux.rsn.bth.se>
	 <20030403111505.GC656@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@interlinx.bc.ca,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
In-Reply-To: <20030403111505.GC656@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-04-03 at 13:15, Herv=E9 Eychenne wrote:
> On Thu, Apr 03, 2003 at 12:15:43PM +0200, Martin Josefsson wrote:
>=20
> > Thanks for the report, I'll try to fix it up.
>=20
> > The answer is that I don't have time to check all the time if everythin=
g
> > still applies after new stuff has been added to pom.
>=20
> The best way is probably to have some scripts run regularly, trying
> some patch-o-matic combinations (why not all, as patch is quite
> fast...) to detect incompatibilities automatically, and especially
> report new ones.
> Such a list would be interesting.

If someone builds the scripts needed :)

tcp-window-tracking.patch should soon be updated in cvs to reflect the
changes.

--=20
/Martin
