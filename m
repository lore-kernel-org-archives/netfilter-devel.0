From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Mon, 1 Sep 2014 17:07:23 +0200
Message-ID: <CAOkSjBhJQGyJOJ=VwZmr-vhtPF5LRiCqD54XfOteHDo68X4dWw@mail.gmail.com>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es> <20140826110954.GA5648@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39891 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaIAPHp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:07:45 -0400
Received: by mail-lb0-f180.google.com with SMTP id w7so6113779lbi.11
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Sep 2014 08:07:43 -0700 (PDT)
In-Reply-To: <20140826110954.GA5648@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 August 2014 13:09, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Please, implement this in nft. I think we can probably have an -x
> option, eg.
>
> nft -f -x ruleset-file
>
> The '-x' indicates that you want to flush any previous existing
> configuration before loading this 'ruleset-file'.
>
> -xx could also be used to remove any configuration regarding the
> existing families in the ruleset-file, ie. if the ruleset-file only
> contains a configuration for 'ip', all remaining families are left
> untouched.
>

Hi Pablo, Patrick.

I've looked into how to implement this '-x' option.

I wonder if it worth having better a "formal" command, like
 % nft flush ruleset
 % nft flush ruleset ip
 % nft flush ruleset ip6
 % nft flush ruleset arp
 [...]

This way, a user loading a new ruleset with -f can just put a first
line like this:

=3D=3D=3D=3D=3D=3D=3D=3D=3D
nft flush ruleset
nft add table ip filter
nft add chain ip filter input
nft add rule ip filter input counter
nft add table ip6 filter
nft add chain ip6 filter input
[...]
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Or flush per family, as Pablo suggested:

=3D=3D=3D=3D=3D=3D=3D=3D=3D
nft flush ruleset inet
nft add table inet filter
[...]
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Some benefits of this approach is that we have a concrete order to
flush the ruleset, in the case the user wants no ruleset.
The lack of this shortcut seem an actual concern of some users.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
