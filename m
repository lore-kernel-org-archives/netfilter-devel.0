From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Connection tracking/NAT for Amanda
Date: Fri, 20 Sep 2002 16:47:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920164717.G3810@sunbeam.de.gnumonks.org>
References: <20020913201501.GD2689@pc.ilinx> <20020915132946.K3810@sunbeam.de.gnumonks.org> <20020918154901.GD4059@pc.ilinx>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline; filename="msg.pgp"
In-Reply-To: <20020918154901.GD4059@pc.ilinx>; from netfilter@interlinx.bc.ca on Wed, Sep 18, 2002 at 11:49:01AM -0400
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

On Wed, Sep 18, 2002 at 11:49:01AM -0400, netfilter@interlinx.bc.ca wrote:
> On Sun, Sep 15, 2002 at 01:29:46PM +0200, Harald Welte wrote:
> > On Fri, Sep 13, 2002 at 04:15:01PM -0400, netfilter@interlinx.bc.ca wrote:
> > > Please find attached a patch (to p-o-m) which adds both connection
> > > tracking and NAT support for the Amanda backup protocol.
> > > 
> > 
> > thanks, applied to patch-o-matic.
> 
> Thanks Harald.  Please do note, that the patch you applied does depend
> on a previous patch I sent that I did not see any comment on; whether
> it was applied or not or otherwise.  I don't think it was applied.
> The message I sent previously with the patch can be found at:
> 
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/009012.html
> 
> If you don't like the ip_nat_mangle_multi_udp_packet() function it can
> be removed from the patch, but the rest is needed.

I see. And I indeed don't like the ip_nat_mangle_multi_udp_packet().
I will add your patch to the 'pending' repository.  It will not be 
applied before 2.4.21-pre, though.

> Brian J. Murrell

- -- 
Live long and prosper
- - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9izT1XaXGVTD0i/8RAqZ7AKCAFdpi45I5CWtYblnYGXozStfRyACfVAQW
ZrEWBDk7GLu1zcwfO4fZUdQ=
=vIZ6
-----END PGP SIGNATURE-----
