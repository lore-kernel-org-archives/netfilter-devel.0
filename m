From: Herve Eychenne <rv@wallfire.org>
Subject: Re: ERROR target in /proc/net/ip_tables_targets
Date: Thu, 25 Mar 2004 21:17:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040325201757.GN1115@eychenne.org>
References: <20031127042854.GE1084@eychenne.org> <Pine.LNX.4.58.0311270536590.30430@gw.localnet> <20031127050742.GB2740@eychenne.org> <Pine.LNX.4.58.0311270612230.30430@gw.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0311270612230.30430@gw.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 27, 2003 at 06:20:06AM +0100, Patrick McHardy wrote:

> On Thu, 27 Nov 2003, Herve Eychenne wrote:

> > Yes, except than when you do a cat /proc/net/ip_tables_targets and
> > read "ERROR" at the end of the list, you get the strong (and
> > unpleasant) feeling that something went wrong and that the list may
> > not be complete (even if _you_ (netfilter developer) know it is).

> I never thought of it this way .. I actually had to laugh out about my
> ignorance not realizing what ERROR means to most people ;)

> > So (even if I understand your concerns at the time you wrote the
> > patch) this is IMHO not acceptable.
> > Please, let's not sacrifice "ignorant" user time and confidence for a
> > few duplicate lines of kernel code...

> Yes I totally understand your point, I'm going to fix it when I get
> around.

$ uname -a
Linux comet 2.6.4 #29 Thu Mar 18 19:42:39 CET 2004 i686 GNU/Linux

And it's still there. Is there patch? If yes, it has not been
submitted upstream...

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
