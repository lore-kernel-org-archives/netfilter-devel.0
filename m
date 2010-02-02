From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: NF_STOLEN and re-insert in to IP stack
Date: Tue, 2 Feb 2010 17:46:47 +0530
Message-ID: <4d5b51f61002020416r4df9407byf9e64489f28eb8dc@mail.gmail.com>
References: <d81115a61001300058o65e0c079nf4d8469da024b53c@mail.gmail.com>
	 <d81115a61001300358s82df29fldd01322ea23a612a@mail.gmail.com>
	 <d81115a61001300359q5831092dh35af6c7505a88705@mail.gmail.com>
	 <20100202113832.GS17420@prithivi.gnumonks.org>
	 <d81115a61002020347n91409dav4bb939a13768b05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Susant Sahani <ssahani@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:65185 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0BBMQt convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:16:49 -0500
Received: by ewy28 with SMTP id 28so3769737ewy.28
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Feb 2010 04:16:47 -0800 (PST)
In-Reply-To: <d81115a61002020347n91409dav4bb939a13768b05f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

have a look at nf_reinject  in nf_queue.c

On Tue, Feb 2, 2010 at 5:17 PM, Susant Sahani <ssahani@gmail.com> wrote=
:
> =A0=A0Hi,
>
> =A0=A0I have yet to find any resource that answers this question. =A0=
If I
> =A0have =A0a kernel module that registers a callback with netfilter a=
nd
> =A0steals a =A0packet during the NF_IP_PRE_ROUTING stage, How can I
> =A0re-insert this =A0packet on the network stack, (before the ip rout=
ing
> =A0stage) .
>
> =A0=A0susant
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
