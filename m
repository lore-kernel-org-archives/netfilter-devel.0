From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] RPC match and conntrack modules v2.1
Date: Sat, 11 Jan 2003 01:05:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030111000555.GL9467@sunbeam.de.gnumonks.org>
References: <200301102347.h0ANl1606804@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fPlFr9CTKi+yOJ4Y"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
Content-Disposition: inline
In-Reply-To: <200301102347.h0ANl1606804@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--fPlFr9CTKi+yOJ4Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 11, 2003 at 09:47:01AM +1100, Ian Latter wrote:

> Cool, thanks .. :-)  I think there will be a lot of embedded firewall
> manufacturers that will enjoy this one ...

agreed :)

> That's correct - there was no NAT built into record-rpc, not even in an
> old API.  I wanted to make the module set complete by writing the=20
> corresponding NAT module(s) but I didn't get time.  I might be re-inspired
> later in January if no one else picks it up -- the code should be almost
> identical to the RSH work module that I wrote, because the connection
> handling is quite similar ..... actually ... maybe it doesn't need a
> nat helper; the connections are all initiated from the client to the
> server, and the internal protocols aren't carrying payloads that need
> to be rewritten ... so as long as the nat stuff handles "related"
> streams sanely, then its probably ok ...

no problem, let's just ignore NAT for now.

> > See attached patch.  Mostly CodingStyle updates (you seem to like 8 spa=
ces
> > instead of tab), but also a minor fix:
> Cool ... could you resent it as a "zip" attachment ... my mail software
> decodes text attachments which will make all the tabs in your patch
> spaces again ...

well, here it is as .gz again.  Strange mailclient you must be using...

> > btw: I'd really love to see the large chunk of code in the switch
> > statement of the match() function in ipt_rpc.c be split up in seperate
> > functions (thus reducing indentation and improving readability).
> possibly could be ... the gumby way might be to do udp and tcp
> functions ... but a better way might be to pull out the rpc payload
> stuff .... I can take a look at that.

thanks.

> > I don't know, but I think esp. in cases where you have lots of rpc
> > activity (NFS?, I'm not an RPC expert) it might be wise to use a slab
> > cache for the 'struct request_p' list items.
> I have not done that before, is there  an example some place in the
> existing modules?

yes, it's done in ip_conntrack_core. see kmem_cache_create /
kmem_cache_alloc / and related functions.   The idea is for the memory
management to keep a pool of memory chunks of the requested size around,
in case they are heavily allocated / deallocated.  We do this with
struct sk_buff, struct ip_conntrack.

I'm not sure whether it's worth the effort in the rpc case... But if I'm
not mistaken in NFSv2, every single file in an 'ls' is a seperate RPC
request/reply, isn't it?

> > Please integrate my patch [and maybe consider my suggestions, that's of
> > course up to you], test it and resubmit it.
> hopefully be done by the end of the weekend/early next week.

no problem, I'll be off over the wekend anyway.

> > Thanks!
> Thanks for taking a look at it, and providing feed back ...

You're welcome.
> --
> Ian Latter

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--fPlFr9CTKi+yOJ4Y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+H1/jXaXGVTD0i/8RAgZjAKCgIsimKFSJUicbchPsWp71rAah4QCeOiY6
eLPlTBhnYEAQVa72iLyZI0o=
=zJYL
-----END PGP SIGNATURE-----

--fPlFr9CTKi+yOJ4Y--
