From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: iptables-save saves invalid negative --uid-owner expressions.
Date: Mon, 6 Jan 2003 09:07:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301060907.39251.bdschuym@pandora.be>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr> <20030106020219.GC423@comet.rv-int>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?q?Herv=E9=20Eychenne?= <rv@wallfire.org>
In-Reply-To: <20030106020219.GC423@comet.rv-int>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 06 January 2003 03:02, Herv=E9 Eychenne wrote:
> It seems to me that no single week passes without any post about this
> kind of error (no space before a negation) in some save output module.
> Sigh.
> I must admit it seems quite strange to me that noone in the coreteam
> didn't do that already. (hope I won't hurt anybody's feelings too
> much though) ;-)
>
> Would someone who's even more fed up than me with these recurrent
> messages have time to audit the whole bunch of existing modules in
> the CVS tree and fix this particular kind of problem _once and for all_=
?

All these potential bugs could be solved by using a scheme in which no ne=
w=20
file format is introduced :) A scheme where the table is saved to a file=20
instead of to the kernel until all modifications are done is really not t=
hat=20
hard to do. It's being done in ebtables... With this scheme, introducing =
a=20
new module keeps everything working.

--=20
cheers,
Bart
