From: Herve Eychenne <rv@wallfire.org>
Subject: Re: tcp-window-tracking for 2.6? (Re: [PATCH] patch-o-matic-ng reorganization and updated patches)
Date: Fri, 20 Feb 2004 12:08:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220110847.GB1165@eychenne.org>
References: <87vfm27u28.fsf@iki.fi> <Pine.LNX.4.33.0402201000370.16037-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402201000370.16037-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 20, 2004 at 10:12:24AM +0100, Jozsef Kadlecsik wrote:

> On Thu, 19 Feb 2004, Nuutti Kotivuori wrote:

> > > - 2.6 ports of tcp-window-tracking and conntrack_foo patches
> >
> > I am personally very interested in the state of the
> > tcp-window-tracking patch, especially for 2.6 kernels. It is very nic=
e
> > to know it is being ported for 2.6.
> >
> > What I would be doing would either be a patch that depends on the
> > tcp-window-tracking patch to work at all - or it would do something
> > similar itself which would most probably make it conflict with the
> > tcp-window-tracking patch.
> >
> > Does anyone know of the status it? How far is it from being integrate=
d
> > into the mainline netfilter? Are there any blocking issues why it
> > cannot be or will not be integrated?

> Weren't it be ported to 2.6, couldn't it been submitted into
> inclusion :-).

> Thanks to Willy Tarreau's suggestions, patches and heavy testings, the
> patch matured a lot. I'd say there is nothing against submitting it int=
o
> the kernel in the near future.

At the workshop, you presented benchmarks showing that the box seemed
to run faster with tcp-window-tracking patch (!), surprising us all very
much. In the meanwhile, could someone figure out why?

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
