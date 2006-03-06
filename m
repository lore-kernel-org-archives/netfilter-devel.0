From: Stephen Frost <sfrost@snowman.net>
Subject: Re: BUG: More ipt_recent queries
Date: Sun, 5 Mar 2006 22:04:11 -0500
Message-ID: <20060306030411.GZ4474@ns.snowman.net>
References: <dt51lh$b63$1@sea.gmane.org> <43FAF692.8030804@ufomechanic.net>
	<44096842.3010507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YXu4p6UMuja7fppQ"
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44096842.3010507@trash.net>
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


--YXu4p6UMuja7fppQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Patrick McHardy (kaber@trash.net) wrote:
> Stephen, can you have a look at this please?

Alright.  I'll try to look over the current ipt_recent state and the
comments I've seen regarding it.  I don't expect to have time to
rewrite it anytime soon though.

	Stephen

> Amin Azez wrote:
> > I'm concerned about ipt_recent where it removes entries from the list.
> >=20
> > Surly the move-up-and-close-the-gap while loop will never enter because
> > time_info[time_loc].time has just been set to 0 so that this clause of
> > the while loop:
> >=20
> >   time_info[(time_loc+1) % ip_list_tot].time < time_info[time_loc].time)
> >=20
> > will always be false.
> >=20
> > Fuller code segment:
> >=20
> > location =3D hash_table[hash_result];
> > hash_table[r_list[location].hash_entry] =3D -1;
> > time_loc =3D r_list[location].time_pos;
> > time_info[time_loc].time =3D 0;
> > time_info[time_loc].position =3D location;
> >=20
> > while((time_info[(time_loc+1) % ip_list_tot].time <
> > time_info[time_loc].time) && ((time_loc+1) % ip_list_tot) !=3D
> > curr_table->time_pos) {
> >   time_temp =3D time_info[time_loc].time;
> >   time_info[time_loc].time =3D time_info[(time_loc+1)%ip_list_tot].time;
> >   time_info[(time_loc+1)%ip_list_tot].time =3D time_temp;
> >   time_temp =3D time_info[time_loc].position;
> >   time_info[time_loc].position =3D
> >              time_info[(time_loc+1)%ip_list_tot].position;
> >   time_info[(time_loc+1)%ip_list_tot].position =3D time_temp;
> >   r_list[time_info[time_loc].position].time_pos =3D time_loc;
> >   r_list[time_info[(time_loc+1)%ip_list_tot].position].time_pos =3D
> >              (time_loc+1)%ip_list_tot;
> >   time_loc =3D (time_loc+1) % ip_list_tot;
> > }
> >=20
> >=20
> > I think we should set time_info[time_loc].time =3D 0; at the end of the
> > while loop?
> >=20
> > Sam
> >=20
> >=20

--YXu4p6UMuja7fppQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEC6aqrzgMPqB3kigRAlIQAJ9zepDRa/R6qymiVrjYdjf02JcCyQCghwSf
9EoWP+ULQoFy0ZfnP85Alag=
=RcWj
-----END PGP SIGNATURE-----

--YXu4p6UMuja7fppQ--
