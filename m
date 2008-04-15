From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 7/8] [NETFILTER]: Collapse tcpmss_reverse_mtu{4,6} into
 one function
Date: Tue, 15 Apr 2008 15:57:42 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804151554260.13202@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <b98252de900f8adedc682997216cc4f9dc4d5a4a.1207668694.git.jengelh@computergmbh.de> <4804A4D5.4090707@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35477 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYDON5n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:57:43 -0400
In-Reply-To: <4804A4D5.4090707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-04-15 14:51, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>> ---
>>  net/netfilter/xt_TCPMSS.c |   42 +++++++++++-----------------------=
--
>>  1 files changed, 13 insertions(+), 29 deletions(-)
>
> Applied, thanks.
>
> Please resend all AF_UNSPEC/arptables/ebtables related patches
> once you've done the remaining fixes.
> --

The patch queue (in testing) has no more fixes; am I missing patches?

=E2=94=80=E2=94=80[NETFILTER]: Collapse tcpmss_reverse_mtu{4,6} into on=
e function
=E2=94=80=E2=94=80[NETFILTER]: Use unsigned types for hooknum and pf va=
rs
=E2=94=80=E2=94=80[NETFILTER]: Rename ipt_recent to xt_recent
=E2=94=80=E2=94=80[NETFILTER]: xt_recent: IPv6 support
=E2=94=80=E2=94=80[NETFILTER]: xt_recent: make old proc interface confi=
gurable
=E2=94=80=E2=94=80[NETFILTER]: xt_length match, revision 1
=E2=94=80=E2=94=80[NETFILTER]: Introduce NFPROTO_* constants
=E2=94=80=E2=94=80[NETFILTER]: Use NFPROTO_* in extensions
=E2=94=80=E2=94=80[NETFILTER]: Implement NFPROTO_UNSPEC as a wildcard f=
or extensions
=E2=94=80=E2=94=80[NETFILTER]: Make Ebtables use Xtables infrastructure
=E2=94=80=E2=94=80[NETFILTER]: Move ARPREPLY to net/netfilter/
=E2=94=80=E2=94=80[remotes/origin/HEAD]=E2=94=80=E2=94=80[remotes/origi=
n/master]=E2=94=80=E2=94=80[NETFILTER]: Deploy a prefix-length


> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
