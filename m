From: Jimmy Hedman <jimmy.hedman@southpole.se>
Subject: Re: ULOG problem
Date: 30 Oct 2002 17:01:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1035993698.1216.6.camel@goofy>
References: <3DBFFDA2.1020108@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart <b-m@pandora.be>
In-Reply-To: <3DBFFDA2.1020108@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
the CVS contains a fix for this.

// Jimmy

On Wed, 2002-10-30 at 16:41, Bart wrote:
> Hi,
>=20
> When I insert a rule like this:
>=20
> -j ULOG --ulog-prefix "inet in"
>=20
> then iptables-save will show:
>=20
> -j ULOG --ulog-prefix inet in
>=20
> and restoring won't work...
>=20
> Is there already a fix for this ?
>=20
> Greetz
>=20
>=20
--=20
Jimmy Hedman                       South Pole AB
Phone:  +46 8 51420420             Gelbjutarv=E4gen 5
Fax:    +46 8 51420429             SE - 17148 Solna=20
e-mail: jimmy.hedman@southpole.se  www.southpole.se
