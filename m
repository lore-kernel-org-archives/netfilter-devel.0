From: Herve Eychenne <rv@wallfire.org>
Subject: Re: iptables-save dump option
Date: Thu, 19 Aug 2004 12:18:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819101816.GA4883@eychenne.org>
References: <20040817204256.GC23109@eychenne.org> <20040819101422.GE3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
        Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040819101422.GE3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Aug 19, 2004 at 12:14:22PM +0200, Harald Welte wrote:

> On Tue, Aug 17, 2004 at 10:42:56PM +0200, Herve Eychenne wrote:
> >  Hi,
> >=20
> > Can someone tell me (Harald ?) what is the interest of the -d (--dump=
)
> > option in iptables-save? I don't see it, as it does the same as
> > iptables-save without any arguments... (and it is undocumented in the
> > manpage)

> The initial idea was to make a binary dump instead of the ASCII parsed
> save file format.  This was never implemented though (and I don't think
> it's worth adding it anymore).

There is already a "--binary" option (not implemented, indeed) for
that... So my question remains...

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
