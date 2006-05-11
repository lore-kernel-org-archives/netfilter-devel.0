From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 13:55:12 +0200
Message-ID: <20060511115512.GI10324@sunbeam.de.gnumonks.org>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
	<4462CD64.1060507@net.in.tum.de>
	<20060511083925.GD10324@sunbeam.de.gnumonks.org>
	<4462F95A.7060305@trash.net> <4462FCE0.20300@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Gregor Maier <gregor@net.in.tum.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Holger Eitzenberger <heitzenberger@astaro.com>
Content-Disposition: inline
In-Reply-To: <4462FCE0.20300@astaro.com>
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

On Thu, May 11, 2006 at 10:59:12AM +0200, Holger Eitzenberger wrote:

> IMO this is the best solution too, since the current way is not very tran=
sparent to the user.  Worse=20
> than that, ULOG even is stamped "deprecated" in kconfig of 2.6.15.y, so m=
ost people will just be able=20
> use the limited arguments of the LOG target.

JFTI: that deprecated has been removed in more current mainline kernels.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
