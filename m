From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] newnat conntrack/nat core support for UDP protocols
Date: Fri, 20 Sep 2002 17:13:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920171308.N3810@sunbeam.de.gnumonks.org>
References: <20020816080649.GD2264@pc.ilinx>
Mime-Version: 1.0
Content-Type: application/pgp; x-action=sign; format=text
Cc: netfilter@interlinx.bc.ca
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="msg.pgp"
In-Reply-To: <20020816080649.GD2264@pc.ilinx>; from netfilter@interlinx.bc.ca on Fri, Aug 16, 2002 at 04:07:17AM -0400
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

On Fri, Aug 16, 2002 at 04:07:17AM -0400, netfilter@interlinx.bc.ca wrote:
> Please find below a patch to modify some existing and add some new
> convenience functions to the newnat core conntrack and nat functions.
> 
> In summary:
> 
>  - make ip_nat_resize_packet more generic (TCP and UDP)
>  - optimize away the memmove in ip_nat_mangle_tcp_packet when the
>    replacement string is the same size as the match string
>  - add ip_nat_mangle_udp_packet

aren't you missing that UDP packets can have no checksums, and we thus should
not calculate one?

If this is true, please fix this problem and resubmit.

>  - add ip_nat_mangle_multi_udp_packet

As stated in my other mail, I don't really see the need for this function.
We shouldn't bloat the code and add more API functions for a little gain
in efficiency in some rare cases.

> Thanx,
> b.

- -- 
Live long and prosper
- - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9izsEXaXGVTD0i/8RAuHEAKCURi8S57EpMJ+za2/MFZHSy0SvpgCfevFD
ve0TRRMGU/ua/a9MdnfPP7U=
=Kv41
-----END PGP SIGNATURE-----
