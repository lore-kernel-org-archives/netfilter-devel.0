From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: Accounting objects support in nft
Date: Mon, 12 Jan 2015 12:48:35 +0100
Message-ID: <CAOkSjBi6K9t0W5Nv=mBwNUMbzT3UeFsMoadqzkBpSfDqJ3tJUQ@mail.gmail.com>
References: <cover.1421059192.git.ana@soleta.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: ana@soleta.eu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:45832 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbALLs4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:48:56 -0500
Received: by mail-la0-f43.google.com with SMTP id s18so23552028lam.2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2015 03:48:55 -0800 (PST)
In-Reply-To: <cover.1421059192.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 January 2015 at 11:55,  <ana@soleta.eu> wrote:
>
> table ip filter {
>         acct http-traffic { pkts 779 bytes 99495}
>         acct https-traffic { pkts 189 bytes 37824}
>
>         chain output {
>              type filter hook output priority 0;
>              tcp dport http acct http-traffic
>              tcp dport https acct https-traffic
>         }
> }
>

Interesting, Ana!

I understand that acct objects are bounded to a table/family.
Why not make them globals? So we could increment same counters from
different families/tables.

best regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
