From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft] segfault, bitmask datatype without parse() function
Date: Tue, 25 Nov 2014 18:25:11 +0100
Message-ID: <CAOkSjBisazG5HVCet27k9R+-6wP7VkSSZfn21G+wN40hLjnQbw@mail.gmail.com>
References: <CAOkSjBhYt+tnDo7vP=bz5hP37cePGxvW2TApPtbXdA0FKkx9dg@mail.gmail.com>
 <20141125154341.GA3579@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53301 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaKYRZd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:25:33 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so1012181lbj.41
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2014 09:25:31 -0800 (PST)
In-Reply-To: <20141125154341.GA3579@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 November 2014 at 16:43, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Tue, Nov 25, 2014 at 01:53:20PM +0100, Arturo Borrero Gonzalez wro=
te:
>> Hi,
>>
>> It seems there is a segfault in nft.
>>
>> How to reproduce:
>>
>> % nft add rule inet filter ct state established,related accept
>
> Where is the chain there?
>
> I think this crash happens in an error path.
>

Ops.. yes, the error happens somewhere in the error path.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
