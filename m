From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 0/1] netfilter: nf_tables: fix big endian problems
Date: Sat, 12 Apr 2014 15:19:35 +0200
Message-ID: <CAOkSjBhfc8ApjoPxze3tvn4d+ochLOi8hqf7S_PmipGjvmaveA@mail.gmail.com>
References: <1397301477-16204-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:60024 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaDLNT5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 09:19:57 -0400
Received: by mail-la0-f49.google.com with SMTP id mc6so4281998lab.8
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Apr 2014 06:19:56 -0700 (PDT)
In-Reply-To: <1397301477-16204-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 April 2014 13:17, Patrick McHardy <kaber@trash.net> wrote:
> This is the last patch required to fix the big endian problems observ=
ed
> by Arturo on Sparc. The changelog contains a detailed explanation of =
the
> problem.
>
> This should also go to -stable.
>

Thanks Patrick.

Best regards.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
