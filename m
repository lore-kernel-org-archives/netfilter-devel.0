From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] netfilter project calls for volunteers
Date: Sun, 11 Jan 2004 19:03:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040111180345.GL20706@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHuqAdgBYNjQz/wy"
Cc: lwn@lwn.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lHuqAdgBYNjQz/wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Since netfilter/iptables is a volunteer based effort, the project lives
by more participation and involvement of it's user community.

While we receive lots of code contributions (new matches/targets,
patches, bugfixes, ...), there is lots of work in different areas that
needs to be taken care of.

The netfilter core team is currently looking for help in the following
areas:

1) Converting our old Linuxdoc SGML HOWTO's to Docbook XML

The various HOWTO's have been written years ago, in the now deprecated
Linuxdoc SGML DTD.  There is an XSL to transform it into linuxdoc SGML,
and it needs some further manual cleanup after that transformation
process.  This needs to be done for the english master documents as well
as for the translations.=20

If you are familiar with working with SGML/XML and the respective
toolchain and willing to help us in that matter, please contact
coreteam@netfilter.org.


2) Development of a mirror-consistency-checking script

It is important to us, that the netfilter.org mirrors always have the
latest up-to-date information on them.  To guarantee this, we would like
to have a script that can be run as cron job.  That script would
recursively download all pages from a given mirror site, and compare
them with the content of the master server.  This would have to be for
both, ftp and www mirrors.  Preferred scripting language is Perl.

Since this seems to be a quite common job, I've been browsing
freshmeat.net for something like this.  Unfortunately, I was unable to
find something.  If you know such a script or are willing to write one,
please contact coreteam@netfilter.org.


3) Tune our docbook-website XSL's to produce 100% valid XHTML 1.0

The new homepage (http://www.netfilter.org/) is built from XML in
docbook-website 2.4.1 DTD.  We have some custom modified XSL's, and the
result is not always valid XHTML.  =20

You should be familiar with XML, XHTML and XSL if you want to volunteer
in that area.  docbook-website is quite easy to understand. =20


4) Maintainance of the lists.netfilter.org mailman mailinglists

We're running a number of mailman-2.0 lists on a quite advanced
mailserver with virus scanning (exiscan-acl), spam filtering
(spamassassin).  We're pushing about 50,000 to 100,000 mails per day to
our subscribers.   Administration of the mailinglists (taking care of
bounces that are not automatically detected, stupid users who are unable
to unsubscribe them, post held for moderation, ...) is currently done=20
by Harald, who would rather spend more time on development than on=20
daily-mailman-webinterface-clicking. =20

Anybody who knows how to use a mailman web frontend and is masochistic
enough for the job would be accepted :)


5) Maintainance of 'Links' section on our homepage

The http://www.netfilter.org/links.html page is looking almost the same
for a couple of years.  Nobody is taking care of them really, nobody
checks for broken links. =20

It really needs somebody to collect links for pages related to
netfilter/iptables on the web, and maintaining that list of links.

Ideally we would have a database-generated categorized links section
(not only a single page) on our website, where people could suggest new
links (to be approved by a moderator) via a HTML form.  If yoou want to
hack up a bunch of scripts, that would be great - but that is optional.


6) Maintainance of the netfilter/iptables FAQ

The netfilter FAQ is not very actively maintained these days.  This is
because the maintainer is (guess who): Harald - and as stated before he
really loves to code, rather than writing text...  Also, he's no longer
reading the netfilter user mainlinglist very frequent anymore, so he's
not a good candidate to know which questions get asked often and which
not.

If you are a frequent reader of netfilter and netfilter-devel, you might
be a good candidate.  You don't have to be the biggest iptables guru for
that kind of job... you just copy the good answers from the mails into the
FAQ ;)

btw: the FAQ has already been converted to Linuxdoc XML :)


7) Customization / Development of a FAQ-O-Matic system

Ideally, we would have an online FAQ-O-Matic system, where people could
post online comments, ask new questions, etc.  However, everything has
to get moderator approval before it appears on the webpage.  Also, all
output would have to be static HTML pages, as we really disapprove
PHP/mod_perl and other dynamic content.  If you know such a sytstem, or
one that could be modified in a way to suit our needs, please contact
us.


If you want to help us in any of those areas, please don't hesitate to
contact coreteam@netfilter.org in advance.   Please don't start on your
own, otherwise uncoordinated and duplicate results can waste your
appreciated ressources.

Thank you very much,

	Harald (for the netfilter core team)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lHuqAdgBYNjQz/wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAAZABXaXGVTD0i/8RAnbAAJ96LLeNYmb4DJo6Gol2FKD6Tixk7QCeIBj6
MEwjyLyc90viqyWecJJE3vk=
=7WZe
-----END PGP SIGNATURE-----

--lHuqAdgBYNjQz/wy--
