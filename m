From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables u32 match code for review/testing/...
Date: Wed, 8 Jan 2003 11:56:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030108105646.GH9467@sunbeam.de.gnumonks.org>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com> <20030106125720.GF9467@sunbeam.de.gnumonks.org> <15897.46884.822054.847738@isis.cs3-inc.com> <20030107185748.GV9467@sunbeam.de.gnumonks.org> <15899.51201.381520.438520@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TJXgsAvz6ds/es3G"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15899.51201.381520.438520@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--TJXgsAvz6ds/es3G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2003 at 10:41:05PM -0800, Don Cohen wrote:
> Harald Welte writes (two separate msgs):
>   > /* *** What's this about?
>   >    Must fit inside union ipt_matchinfo: 16 bytes */
>   What do you mean by this?
>
> That was a comment I found in one of the other match modules
> (which I used as a template for this one).
> I didn't understand it so I thought I better keep it and flag it.
> If you don't know what it's about I guess it's safe to discard it.

Hm. A recursive grep through the kernel doesn't find any occurrance of=20
'ipt_matchinfo' at all.

However, most userspace iptables plugins still contain a comment
referring to union ipt_matchinfo.  I think this is a remnant of the very
early days of iptables [which I have missed].  I think it's safe to
forget about it.

>   > /* *** any way to allow for an arbitrary number of elements?
>   >    for now I settle for a limit of 10 of each */
>   no way. At least not with the current kernel/userspace interface :(
> Ok, then I'll leave it at 10x10x10 (perhaps a lot of overhead for
> a single match?)

It also means that every single rule containing the u32 match will
occupy smp_num_cpus*1000*sizeof(your structure) bytes of non-swappable
kernel memory.

>  > I like the content (code/implementation/idea of having u32).
>  > The only issue is that it doesn't really fit into the current iptables
>  > architecture. Why?
>  > 	- because it is a whole classification engine on it's own
> Why is this bad?  I wrote it to do things I wanted to do but didn't
> see how.  I think that's good.  If it subsumes a few others that are
> out there, even better.  (But it's almost certainly a lot slower than=20
> any more specialized match, so they're still useful.)

Sorry, I didn't make myself clear.  if u32 is used the right way, it is
way better than lots of the static matches within iptables.  However, it
is more like a replacement of the whole iptables packet matching engine,
than a plugin/extension to it.  Making it a plugin/extension will
unfortunately become a sort-of clumsy approach.   I don't blame or
critisize you... this is not an issue of implementation, but a
fundamental architectural problem.

>  > 	- because it has an arbitrary [variable] amount of match data
> At the moment, a large fixed amount.  I regard that as a fault of
> current iptables, though.

I totally agree.  I said "it doesn't really fit into the current
iptables architecture". =20

>  > > Was the indentation a problem?  The tabs were all 8 spaces, but
>  > > perhaps you want wider indentation?
>  > no, but look at the structure definitions in your header file.
> Oops.  The "no" above suggests that you don't mind the narrow
> indentation, in which case not only the .h file but the earlier
> versions of the .c files were ok except for the few misplaced }'s.

I really should work on the precision of my language, it seems.

the indentation was a problem, yes. no, I don't want wider indentation
than 8.

> But if you do want wide indentation (and don't mind >80 cols)
> then here you go:

yes.  If you now would be as friendly to post it as a unified diff
against current patch-o-matic CVS, attached in MIME format?  (And for
posting habits and/or coding style hints there are plenty of examples in
the list archives respectively CVS).

Thanks again.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--TJXgsAvz6ds/es3G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HAPuXaXGVTD0i/8RAp4TAKCCKJMkq5X9Ah8+XFu/8x+EtVH5cQCdGkva
XKd3QtDys4Als/S2Uv5U1dM=
=vrUn
-----END PGP SIGNATURE-----

--TJXgsAvz6ds/es3G--
