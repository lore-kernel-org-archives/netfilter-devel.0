From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Tue, 14 Jan 2003 02:14:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301140214.20895.bdschuym@pandora.be>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <200301140053.04301.bdschuym@pandora.be> <3E234A92.50606@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: laforge@gnumonks.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
In-Reply-To: <3E234A92.50606@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 14 January 2003 00:24, Anders Fugmann wrote:
> Ahh. I misread. I read it as "overcommit" and not as you wrote
> "overcomment" :-).
>
> It is a double check as try_module_get also tests for arguemtn=3D=3DNUL=
L.
> This example is take out of context. Its fine by me if you dont like
> comments in code but IMHO documentation is vital and comments are
> usually not harming anyone. I can remove all comments in the next patch
> if you like. (I dont, but then again - who am I to decide.)

try_module_get is a function that will be used all over the kernel, so it=
's my=20
feeling that the reader should have no problem with understanding this.=20
Anyway, I'm not the one who's the final judge, Rusty or Harald seem to be=
=20
more appropriate, I'm just trying to help :) Maybe you should CC Rusty (
Rusty Russell <rusty_at_rustcorp.com.au>) if you post another patch for t=
his.=20
Then again, maybe he is too busy with other stuff now...

> > Can't you just change
<snip>
> No. At this point the replace has already occured, and we must ignore
> the error if anything. The above is wrong as we cannot abort at that
> point. (If I understand the code correctly - Please correct me if I'm
> wrong).

Aha, it's been more than a year (two years would be more accurate) since =
I've=20
read the iptables code and I see this code was added since then. My comme=
nt=20
in another mail about the table module count not being increased when new=
=20
rules are added is probably wrong then. I don't really see why this code =
is=20
in here since the original code was made so that an rmmod of a non-empty=20
table would just empty the whole table first. That code now seems useless=
=2E A=20
quick scan of the netfilter devel list of around the time this code was a=
dded=20
doesn't show anything.

> Agreed, But I really believe that the the change discussed is nessesary=
=2E
> (There are two of these).

Yes, my bad.

--=20
cheers,
Bart
