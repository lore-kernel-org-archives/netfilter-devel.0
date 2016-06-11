From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft] tests: shell: make testcases which using tcp/udp port
 more rubost
Date: Sat, 11 Jun 2016 12:04:57 +0200
Message-ID: <CAOkSjBj03cgzEr4b+y8suT65iGBVX61O8GzAh=HgRObNw1DCMg@mail.gmail.com>
References: <1465621514-25589-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34150 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbcFKKFS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 06:05:18 -0400
Received: by mail-wm0-f46.google.com with SMTP id k184so6860161wme.1
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2016 03:05:18 -0700 (PDT)
In-Reply-To: <1465621514-25589-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 June 2016 at 07:05, Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
>
> In my mechain, port 12345 is mapped to italk in /etc/services:
>   italk           12345/tcp               # Italk Chat System
>
> So when we add nft rule with udp port "12345", nft list ruleset
> will displayed it as "italk", that cause the result is not same
> with expected, then testcase fail.
>
> Add "-nn" option when dump the rulesets from the kernel, make
> testcases which using tcp/udp port more rubost.
>
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  tests/shell/testcases/netns/0001nft-f_0         | 2 +-
>  tests/shell/testcases/netns/0002loosecommands_0 | 2 +-
>  tests/shell/testcases/netns/0003many_0          | 2 +-
>  tests/shell/testcases/nft-f/0002rollback_rule_0 | 2 +-
>  tests/shell/testcases/nft-f/0003rollback_jump_0 | 2 +-
>  tests/shell/testcases/nft-f/0004rollback_set_0  | 2 +-
>  tests/shell/testcases/nft-f/0005rollback_map_0  | 2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
>

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
