From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 15:24:18 -0700
Message-ID: <BANLkTimJKxShXcxaS7AijtDwvhET0zLWOg@mail.gmail.com>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	<1309340843.2532.112.camel@edumazet-laptop>
	<BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	<1309342096.2532.116.camel@edumazet-laptop>
	<4E0C15A3.9050609@yandex.ru>
	<1309416426.2532.119.camel@edumazet-laptop>
	<4E0C278B.7010403@yandex.ru>
	<1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<4E0C651A.1000300@trash.net>
	<1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59152 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1F3WYT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:24:19 -0400
Received: by wwe5 with SMTP id 5so2675054wwe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 15:24:18 -0700 (PDT)
In-Reply-To: <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 30, 2011 at 8:15 AM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le jeudi 30 juin 2011 =E0 13:59 +0200, Patrick McHardy a =E9crit :
>
>> Thanks Eric, I agree. Give us data and we'll fix it if really is a b=
ug.
>>
>> The fact that the timeout patch apparently helps indicates that some
>> packets don't receive verdicts.
>
> My rough guess is that this user application gets an error in its
> nfq_set_verdict() call ( maybe a transient out of memory indication) =
and
> packet never gets its verdict.

Hows does ENOBUFS interact with the queue? Is it possible that the
kernel->userspace notification of the packet id gets dropped, and
userspace is thus never notified of the packet id, and can't issue a
verdict?

Sam
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
