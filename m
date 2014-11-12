From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [iptables PATCH v2] iptables/nft-shared.c: kill add_*() invflags parameter
Date: Wed, 12 Nov 2014 13:44:27 +0100
Message-ID: <CAOkSjBgRPF7WqhtN+cmwvZWNt94=aBKb_1gwysOX63p-8VpFLg@mail.gmail.com>
References: <20141112115949.3179.82085.stgit@nfdev.cica.es> <20141112121852.GA1397@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:61825 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaKLMot convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:44:49 -0500
Received: by mail-la0-f47.google.com with SMTP id gd6so11028604lab.6
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2014 04:44:48 -0800 (PST)
In-Reply-To: <20141112121852.GA1397@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 November 2014 13:18, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Wed, Nov 12, 2014 at 01:00:12PM +0100, Arturo Borrero Gonzalez wro=
te:
>> Let's kill the invflags parameter and use directly NFT_CMP_[N]EQ.
>> The caller must calculate which kind of cmp operation requires.
>>
>> BTW, the this patch solves absence of inversion in some arptables-co=
mpat
>> builtin matches. Thus, translating arptables inv flags is no longer =
needed.
>
> Applied, thanks Arturo.

Would you rebase the ebtables branch? So I can apply the same fix there=
=2E

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
