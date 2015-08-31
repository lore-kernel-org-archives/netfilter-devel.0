From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrackd] allowing DisableExternalCache in alarm mode
Date: Mon, 31 Aug 2015 09:55:23 +0200
Message-ID: <CAOkSjBhxLk2beq70jZCTKtO8K09UcSj5jNh2H-9wvCzSL0XxeA@mail.gmail.com>
References: <CAOkSjBh2KtYcSEQ7=h_h+R9CE53pwGtBAiQ_OZF0aTX0fhY0fw@mail.gmail.com>
 <20150828164912.GD3436@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:32817 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbHaHzo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 03:55:44 -0400
Received: by lbbsx3 with SMTP id sx3so55894170lbb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 00:55:43 -0700 (PDT)
In-Reply-To: <20150828164912.GD3436@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 August 2015 at 18:49, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> Are these FTP data flows? I'm asking this because the master
> connection (control flow) may be missing in the conntrack table, thus
> the ENOENT error.

Makes sense.

Would you consider accepting the patch?

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
