From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 15:26:09 -0700
Message-ID: <BANLkTiksYHMU7ojnKMJBj-EQjW8sxTO2Tw@mail.gmail.com>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	<1309340843.2532.112.camel@edumazet-laptop>
	<BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	<1309342096.2532.116.camel@edumazet-laptop>
	<4E0C15A3.9050609@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54435 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1F3W0L convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:26:11 -0400
Received: by wyg8 with SMTP id 8so1848577wyg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 15:26:09 -0700 (PDT)
In-Reply-To: <4E0C15A3.9050609@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 29, 2011 at 11:20 PM, Kuzin Andrey <kuzinandrey@yandex.ru> =
wrote:
> =A0On 29.06.2011 14:08, Eric Dumazet wrote:
>> But if some packets are never dequeued (because something is wrong w=
ith
>> your program, failing to give verdict), they stay forever in the lis=
t
>> and each dequeue is slower since it has to go past these packets...

> I'am using NFQUEUE several years on our main network router, and prob=
lem
> with packets stuck in the queue is still not resolved.

Is there any way to see what the current queue is in the kernel? How
deep, and what  the IDs are?

Cheers,
Sam
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
