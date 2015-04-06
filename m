From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Mon, 6 Apr 2015 09:12:47 +0200
Message-ID: <CAOkSjBis1LsHZgU7A0R6g5vP_WfZ2Xj9UK3krgKotZ0DuRfE7w@mail.gmail.com>
References: <551FC211.6000907@ahsoftware.de> <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
 <20150404115550.GA5832@salvia> <20150405113214.GA23433@acer.localdomain> <20150405121104.GD23433@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexander Holler <holler@ahsoftware.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Eric Leblond <eric@regit.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34279 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbDFHNJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 03:13:09 -0400
Received: by laat2 with SMTP id t2so7599096laa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Apr 2015 00:13:07 -0700 (PDT)
In-Reply-To: <20150405121104.GD23433@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 April 2015 at 14:11, Patrick McHardy <kaber@trash.net> wrote:
>
> This needs a lot of testing though since it has the potential to brea=
k
> things quite badly. Since I'm busy, maybe someone else wants to start=
 by
> running the testsuite with this patch applied.

I was curious and ran the testsuite with your patch. It's OK.

best regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
