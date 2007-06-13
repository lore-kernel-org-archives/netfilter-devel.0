From: "Fabrice Rafart" <fabrice.rafart@efs.sante.fr>
Subject: RE: Follow packets in rules
Date: Wed, 13 Jun 2007 09:31:02 +0200
Message-ID: <002101c7ad8c$cb6d67c0$1706380a@adidf.efs.sante.fr>
References: <f7de5e030706121441h6b817d82td49e3eb4346e5a12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "'Simon'" <simon.xhz@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <f7de5e030706121441h6b817d82td49e3eb4346e5a12@mail.gmail.com>
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

> -----Message d'origine-----
> De : netfilter-devel-bounces@lists.netfilter.org=20
> [mailto:netfilter-devel-bounces@lists.netfilter.org] De la=20
> part de Simon
> Envoy=E9 : mardi 12 juin 2007 23:41
> =C0 : Fabrice Rafart
> Cc : netfilter-devel@lists.netfilter.org
> Objet : Re: Follow packets in rules
>=20
> On 6/12/07, Fabrice Rafart <fabrice.rafart@efs.sante.fr> wrote:
> > Hello,
>=20
> Salut Fabrice!
>=20
> > I look for a tool to follow a packets into rules of netfilter.
> [...]
> > This show me which rules matches the packet until the end.
>=20
> I'm not sure if such a tool exists, but there is a way to follow the
> packets very well.
> Using the LOG target, you can log packets as they match certain rules
> and you can put a message to be put in the log to identify that line.
>=20
> After, you just have to grep the logfile for patterns matching the ip
> address and you should see the history of each packets that came in.
>=20
> You could make your own target queues like LOGDROP or LOGACCEPT and
> have a log rule followed by the drop/accept rule.

Thanks for your answer.

I know this possibility and I use it for log some packets but I can't =
double
all my rules (almost 200) by a log rule.

Cordialement,
--=20
Fabrice Rafart
Administrateur syst=E8mes et r=E9seaux
Etablissement fran=E7ais du sang, Ile de France.=20
