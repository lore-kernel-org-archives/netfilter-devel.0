From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] multiple devices with ranges match support
Date: Fri, 20 Sep 2002 17:07:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920170741.M3810@sunbeam.de.gnumonks.org>
References: <638AA0336D7ED411928700D0B7B0D75B03053C9C@aimail.aiinet.com> <20020918221212.GG10465@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline; filename="msg.pgp"
In-Reply-To: <20020918221212.GG10465@oknodo.bof.de>; from bof@bof.de on Thu, Sep 19, 2002 at 12:12:12AM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thu, Sep 19, 2002 at 12:12:12AM +0200, Patrick Schaaf wrote:
> > Would you ever want to use this on interfaces with secondary addresses, like
> > eth0:4?  (Does that even matter?  I'm not too familiar with them; I just
> > remember seeing that syntax.)
> 
> Their use is deprecated (use "ip addr add ..." instead), but it's
> nevertheless a good idea to avoid actively breaking them. However,
> if I remember correctly, they don't really appear as input or
> output device of real packets in the kernel, so in this place,
> it's probably OK to reuse ':'.

true.

> However, in general, I'm not so sure that it makes sense to expand
> all kinds of match options into multidimensional specification
> languages for arbitrary subsets of their keyspaces, with all kinds
> of option specific shortcut forms for how ranges and patterns are
> written. Each option becomes its own mini-language. I don't like.

You seem to be reading my mind.  I already had this issue with the
multiport match (I never liked it, in fact) - and I have the same 
trouble with this kind of patches.  Somebody seems to be solving a 
particular problem (efficiency?) the wrong way.

>   Patrick
> 
> P.S.: My deepest apologies, Jay, for you receiving so many rants from
> me this evening. Please, don't take them personally. I hope to help.

I would consider this a philosophic discussion, it's not about people.

- -- 
Live long and prosper
- - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9izm9XaXGVTD0i/8RAvtNAJ4wpuj5cx8VMtSqhguFri9fbd1IfQCcDiPg
NxAQ1o9h7qZHDsFZqSQyrkE=
=oeeR
-----END PGP SIGNATURE-----
