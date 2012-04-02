From: Amm Snort <ammdispose-snort@yahoo.com>
Subject: Re: NFQUEUE target with --treat-accept-as-continue?
Date: Mon, 2 Apr 2012 11:11:34 +0800 (SGT)
Message-ID: <1333336294.99244.YahooMailNeo@web193406.mail.sg3.yahoo.com>
References: <1333202982.55963.YahooMailNeo@web193402.mail.sg3.yahoo.com> <20120401175159.GA11401@1984>
Reply-To: Amm Snort <ammdispose-snort@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm40-vm3.bullet.mail.sg3.yahoo.com ([106.10.151.206]:39066 "HELO
	nm40-vm3.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754034Ab2DBDS0 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:18:26 -0400
In-Reply-To: <20120401175159.GA11401@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>





----- Original Message -----
> From: Pablo Neira Ayuso <pablo@netfilter.org>

>>  So my request and suggestion is to add additional parameter to NFQU=
EUE
>>  say, --treat-accept-as-continue (or rule not matched)
>>=20
>>=20
>>  which means, if QUEUE program returns NF_ACCEPT then instead of ACC=
EPTing
>>  the packet, continue processing next rule. (as if rule did=A0 not m=
atch)


>=20
> That will not be straight forward to implement. The existing code doe=
s
> not provide a way to resume packet filtering just after the rule that
> enqueued the packet to user-space.

Umm. so how does NFLOG (libnetfilter_log) do it?

=46rom man page: (for NFLOG)
=A0=A0=A0 Like LOG, this is=A0 a=A0 non-terminating=A0 target, i.e. rul=
e traversal continues at the next rule.

If I am not wrong, NFLOG and NFQUEUE are much similar. If NFLOG can all=
ow to continue to
next rule, may be NFQUEUE can, as well.

We already have --queue-bypass option which bypasses to next rule of QU=
EUE is not present.
May be we can have modification to code, which bypasses when NF_ACCEPT =
is received from
userspace.

Just a suggestion, I am not sure if this would need changes at kernel l=
evel.

Thanks
AMM

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
