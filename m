From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: Idea: string replace
Date: Tue, 1 Oct 2002 23:06:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021001210650.GC22145@noir.cb.ac.at>
References: <20021001011306.GG16521@noir.cb.ac.at> <20021001072702.GA23302@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021001072702.GA23302@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2002 at 09:27:02AM +0200, Patrick Schaaf wrote:
> Hi Peter,
Hi.

> > I have an idea, which is IMHO very suitable for China. Er, no, wanted to say
> > something different, suitable for me. How about adding a --replace-with option
> > to the string match? Is it difficult?
> I assume that you are aware of the reasons why the STRING approach
> risks both false positives and false negatives, and I'll spare you
> the usual rant.
I understand that both cases can occur, and for what I need it I accept this.

> Regarding the "is it difficult" question, that depends on whether you
> want to replace with a string of identical length (piece of cake),
Actually, I didn't think so far as to use different lengths, somehow I
subconsiously assumed it is far from easy. Again, I only need this for a very
specific purpose (disabling one virus), for which IMHO same-length-replace is
sufficient.

So, I took a look at the source, and I assume this is indeed trivial,
something like
char *temp;
if ((temp = search (blahblah)) != NULL) {
	if (info->replace != NULL)
		memcpy (temp, info->replace, min (match_length, replace_length));
	return 1 ^ info->invert;
} else
	return 0 ^ info->invert;

The more difficult thing seems to be the stuff around (userspace integration).

> good luck!
Oh I doubt I am good enough to write different-length-replace function :-)

>   Patrick
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505122023

--
Failure is not an option. It comes bundled with your Microsoft product.

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9mg5qzogxsPZwLzcRAgAtAKCOowEmRMqHFl8tPcsSWuzbGIroUgCfc2X3
jooQ/c9Rwij1wT7WPC/lI+8=
=u2Se
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
