From: Herve Eychenne <rv@wallfire.org>
Subject: Re: modified iptables manpage
Date: Tue, 17 Aug 2004 22:56:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040817205627.GD23109@eychenne.org>
References: <20040705115740.GD21294@eychenne.org> <20040708181030.GB5877@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wLAMOaPNJ0fu1fTG"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040708181030.GB5877@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by outmx010.isp.belgacom.be id i7HKuSwV006093

On Thu, Jul 08, 2004 at 08:10:30PM +0200, Herve Eychenne wrote:

> On Mon, Jul 05, 2004 at 01:57:40PM +0200, Herv=E9 Eychenne wrote:

> Here it is:
> - fixed weird characters handling in interface name
>   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D102771&archive=3Dy=
es
> - fixed typo in manpage (the fix was wrong in Debian...)
>   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D197619&archive=3Dy=
es
> - added the default logging level (target LOG) to the manpage
>   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D246037

> There are still some patches in the iptables Debian package, that the
> coreteam may want to apply... it's up to you.

> Sebastien Chaumontet reported that the ability to change only port in
> DNAT was not documented in the manpage. The attached patch fixes that
> as well.

> The patch also reflects the status of the new (ok, this one is pending
> for a few months) emeritus members status.

> Over time, a few people told me that they first had looked for a
> netfilter man page, before finding the iptables one... and I agree
> there should definitely be a small man page about netfilter,
> containing only a little information about the very basic concepts
> and the kernel part, just to clarify things.
> Of course, it is not intended to grow too much, as it would overlap
> with the howto, which is clearly not its goal.
> So I joined a netfilter.7 manpage, as it was pending (too) in
> my tree for a long time. Feel free to include it (and correct by bad
> english) if you find it useful.

> Note: the patch is against current CVS.

Apparently this mail/patch was lost/ignored... may I dare to ask why?

But you won't discourage me ;-), so I send another patch on top of
that.
Eric Raymond sent me an email, as the iptables man page did not pass his
groff validator. He was right, so here is the patch, which also fixes
a typo (address only takes one d in french, so this is a quite common
mistake down here, I guess...)

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/

--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables.patch2"

diff -ruN iptables.old/extensions/libipt_DNAT.man iptables/extensions/libipt_DNAT.man
--- iptables.old/extensions/libipt_DNAT.man	2004-07-08 19:29:46.000000000 +0200
+++ iptables/extensions/libipt_DNAT.man	2004-07-19 21:20:48.000000000 +0200
@@ -27,4 +27,5 @@
 You can add several --to-destination options.  If you specify more
 than one destination address, either via an address range or multiple
 --to-destination options, a simple round-robin (one after another in
-cycle) load balancing takes place between these adresses.
+cycle) load balancing takes place between these addresses.
+.RE
diff -ruN iptables.old/extensions/libipt_SNAT.man iptables/extensions/libipt_SNAT.man
--- iptables.old/extensions/libipt_SNAT.man	2004-01-22 16:04:24.000000000 +0100
+++ iptables/extensions/libipt_SNAT.man	2004-07-19 21:21:16.000000000 +0200
@@ -23,4 +23,5 @@
 You can add several --to-source options.  If you specify more
 than one source address, either via an address range or multiple
 --to-source options, a simple round-robin (one after another in
-cycle) takes place between these adresses.
+cycle) takes place between these addresses.
+.RE

--wLAMOaPNJ0fu1fTG--
