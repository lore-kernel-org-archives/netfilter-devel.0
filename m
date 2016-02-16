From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 4/4] tests: conntrack: add tests for CIDR
 notation
Date: Tue, 16 Feb 2016 19:20:39 +0100
Message-ID: <20160216182039.GF20397@salvia>
References: <1454333407-6335-1-git-send-email-ast@fiberby.dk>
 <1454333407-6335-4-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38454 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669AbcBPSUo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 13:20:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 33AC32273C3
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:20:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 202B71B3D57
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:20:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6EAA291DD
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:20:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454333407-6335-4-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 01, 2016 at 01:30:07PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Signed-off-by: Asbj=F8rn Sloth T=F8nnesen <ast@fiberby.dk>
> ---
>  tests/conntrack/testsuite/01delete | 4 ++++
>  tests/conntrack/testsuite/02filter | 2 ++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/tests/conntrack/testsuite/01delete b/tests/conntrack/tes=
tsuite/01delete
> index 566b89f..194d999 100644
> --- a/tests/conntrack/testsuite/01delete
> +++ b/tests/conntrack/testsuite/01delete
> @@ -10,3 +10,7 @@
>  -D -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.2.2.0 --mask-dst 255.255=
=2E255.0 ; OK
>  # fails due to 0 matches
>  -D -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.2.2.0 --mask-dst 255.255=
=2E255.0 ; BAD
> +# re-create dummy
> +-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN=
 -u SEEN_REPLY -t 50 ; OK
> +# try same command again but with CIDR
> +-D -s 1.1.1.0/24 -d 2.2.2.0/24 ; OK
> diff --git a/tests/conntrack/testsuite/02filter b/tests/conntrack/tes=
tsuite/02filter
> index 5d2270b..58ed070 100644
> --- a/tests/conntrack/testsuite/02filter
> +++ b/tests/conntrack/testsuite/02filter
> @@ -21,5 +21,7 @@ conntrack -L --mark 0 ; OK
>  conntrack -L --mark 0/0xffffffff; OK
>  # filter by netmask
>  conntrack -L -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.0.0.0 --mask-d=
st 255.0.0.0 ; OK
> +conntrack -L -s 1.1.1.4/24 -d 2.3.4.5/8 ; OK
> +conntrack -L -s 1.1.2.0/24 -d 2.3.4.5/8 ; BAD

I have mangled the line above from BAD to OK. The listing above
actually works fine, even if it returns no entries. The tests are not
capable of catching this at the moment IIRC.

So applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
