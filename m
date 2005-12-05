From: Herve Eychenne <rv@wallfire.org>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Mon, 5 Dec 2005 01:45:48 +0100
Message-ID: <20051205004548.GC5617@eychenne.org>
References: <4393895D.1020106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4393895D.1020106@trash.net>
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

On Mon, Dec 05, 2005 at 01:27:09AM +0100, Patrick McHardy wrote:

> I just noticed the TCPMSS target is not restricted to the
> mangle table. Any opinions about whether we should change
> this, perhaps with a warning period?

See the manpage itself... I just copy-pasted the kernel config descriptio=
n
(probably written by Marc Boucher?) when adding TCPMSS to the manpage
some years ago.

So look for TCPMSS, notice the given example:
       iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
                    -j TCPMSS --clamp-mss-to-pmtu

and realize that most uses of TCPMSS (which I fear are not that
rare) probably occur within the filter table.
You can expect a global change to be quite difficult, I guess... :-(

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
