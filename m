From: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
Subject: Re: libiptc/rules with MAC match
Date: Thu, 13 Feb 2003 11:55:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030213105503.GH30133@calix.csn.tu-chemnitz.de>
References: <647994215.20030212211303@habitat-b.de> <15940504432.20030213061453@habitat-b.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
Cc: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
Content-Disposition: inline
In-Reply-To: <15940504432.20030213061453@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 13, 2003 at 06:14:53AM +0100, DarKRaveR wrote:

> I use libiptc to get a rule ...

ok so far.

> there's destinations source, etc.

yep

> if target_offset is bigger than sizeof(struct ipt_entry),
> there's a match present.

yep

> elems points to the first match ...

sorry, you lost me.
I'll just describe what I would do, from the point where you had
ipt_entry, ok? If this is what you did, just skip this part.

struct ipt_entry *e;
struct ipt_entry_match *em;
unsigned int offset;

for(offset =3D sizeof(struct ipt_entry);
    offset < e->target_offset;
    offset +=3D em->u.match_size)=20
{=20
    em =3D (void* )e + offset;
}

> If I cast it to ipt_entry_match, and then check the vars in that
> structure, I can see various sizes etc.
> u.user.name gives me 'mac'.

this looks promising

> but, what I am wondering:
> where can I find the actual mac address ?
> there ipt_entry_match.data, but the data in there didn't make too much
> sense ...

Have you had a look at $IPTABLES_SRC/extensions/libipt_mac.c ?  It is
just right there, at your fingertips. Its the first ETH_ALEN unsigned
chars in match->data. Just look at the function print() in the above
mentioned file and try to parse the output as they do it. Works for them
and works for me, why shouldn't it work for you? ;-)

> Can anyone help me out on that ?

Hope I did.

> And how can I construct a rule myself, that does mac matching ?

iptables -I $chain -m mac --mac-source ...
or have a look at parse_mac() in libipt_mac.c

Happy hacking,
    Thomas

--=20
"If my son wants to be a pimp when he grows up, that's fine with me.  I
hope he's a good one and enjoys it and doesn't get caught. I'll support
him in this. But if he wants to be a network administrator, he's out of
the house and not part of my family."                  -- Steve Wozniak

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+S3mHT7fd1jhuy5cRAv/MAJ4qHV5zT9vaMo06VhI5H9PxZTbDrACggGTY
R8u/SWYqkS5VOAm07p/FcZg=
=/2lK
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
