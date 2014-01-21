From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft RFC PATCH] src: add export operation
Date: Tue, 21 Jan 2014 17:07:39 +0100
Message-ID: <CAOkSjBj4oXHhMjkCqcz-GhM74cekuH2TgkW+GUsM4KsgFAdk7Q@mail.gmail.com>
References: <20140121140545.27264.82385.stgit@nfdev.cica.es> <20140121145131.GA6302@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49899 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaAUQIB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:08:01 -0500
Received: by mail-lb0-f169.google.com with SMTP id q8so6100663lbi.14
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 08:07:59 -0800 (PST)
In-Reply-To: <20140121145131.GA6302@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for your comments Patrick. I'm addressing all of them. Just one
thing below.

On 21 January 2014 15:51, Patrick McHardy <kaber@trash.net> wrote:
>>  struct cmd {
>>       struct list_head        list;
>> @@ -264,6 +267,7 @@ struct cmd {
>>               struct table    *table;
>>       };
>>       const void              *arg;
>> +     uint32_t                format;
>
> No enum defined for this?
>

In libnftables, there are two: `enum nft_parse_type' and `enum nft_outp=
ut_type'.

I preferred just using uint32_t so we can reuse between export/import.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
