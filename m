From: Harald Welte <laforge@netfilter.org>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 22:24:00 +0200
Message-ID: <20050710202359.GA6874@sunbeam.de.gnumonks.org>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
	<42D14A6D.4000900@trash.net>
	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
	<42D1608C.7040909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42D1608C.7040909@trash.net>
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

On Sun, Jul 10, 2005 at 07:53:16PM +0200, Patrick McHardy wrote:

> Thanks for the hint. Harald, if I can't think of anything else (seems
> likely) I'll revert the patch.

Yes, I'm also in favour of reverting the patch.  The number of functional b=
ugs
it has caused by far outweigh the gain of save 'rmmod' without loops.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
