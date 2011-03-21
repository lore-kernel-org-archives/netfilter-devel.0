From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables release plans
Date: Mon, 21 Mar 2011 20:48:23 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103212008460.15338@obet.zrqbmnf.qr>
References: <4D879D96.2000904@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56886 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab1CUTsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:48:25 -0400
In-Reply-To: <4D879D96.2000904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-03-21 19:48, Patrick McHardy wrote:
>
>So the options basically are:
>
>- branch off the current HEAD, remove all new extension for upcoming
>  features and release that branch

I find deletions just for the sake of making a release not very
aesthetic to the git history. It duplicates commits in a way, but
above all, interrupts the flow when tracking changes with "git
blame". Better branch off earlier...
	~/envisioning a git topic for the next NFWS.~


>- skip the release for 2.6.38
>
>Any opinions?

Since there was no iptables release for 2.6.37 was skipped, features
do have accumulated. In fact, there were features added (socket r1)
in 2.6.31 that were not made available up to iptables-1.4.10+git. In
reverse chronological order:

=E2=94=9C=E2=94=80[mdz/master]=E2=94=80=E2=94=80iptables: add -C to che=
ck for existing rules=E2=94=80=E2=94=80(d59b9db)
=E2=94=9C extensions: add extension for devgroup match=E2=94=80=E2=94=80=
(9ee2a9f)
=E2=94=9C Fix listing/saving the new revision of the SET target=E2=94=80=
=E2=94=80(6f03bf7)
=E2=94=9C extensions: libxt_conntrack: add support for specifying port =
ranges=E2=94=80=E2=94=80(c8f28cc)
=E2=94=9C extensions: libxt_NFQUEUE: add v2 revision with --queue-bypas=
s option=E2=94=80=E2=94=80(6924b4
=E2=94=9C libxt_AUDIT: add AUDIT target=E2=94=80=E2=94=80(773438b)
=2E..
=E2=94=82 =E2=94=9C =E2=94=82 socket: add support for revision 1=E2=94=80=
=E2=94=80(4d2a77f)
=E2=94=82 =E2=94=9C =E2=94=82 TPROXY: add support for revision 1=E2=94=80=
=E2=94=80(9e152fa)

	~Graphs produly presented by git-forest. *recordscreech*[1]~


Not to mention a handful of actual program fixes to parsing and
slightly improved robustness (like NULL deref avoidance, I think
there was at least one).

So yeah, time for a release or so. Not for 2.6.38, but for the
general benefit.

Other than that, no, I don't see a reason to do a mandatory filler
release for new kernels when there is nothing "worth" in the
userspace side to make a release of.




--=20
[1] http://www.youtube.com/watch?v=3DoRp_mVi969I
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
