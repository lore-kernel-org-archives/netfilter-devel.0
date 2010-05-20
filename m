From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Thu, 20 May 2010 15:04:24 +0200
Message-ID: <1274360664.4046.36.camel@edumazet-laptop>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58702 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab0ETNE3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 09:04:29 -0400
Received: by fxm10 with SMTP id 10so3513865fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 06:04:27 -0700 (PDT)
In-Reply-To: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 20 mai 2010 =C3=A0 18:21 +0530, Anand Raj Manickam a =C3=A9cri=
t :
> Hi,
> Is there any performance bench mark on conntrack response to 1 millio=
n
> conntrack entries in the conntrack table.
> Since conntrack uses Hashing to lookup the entries i had some doubts
> on the scalability. Can someone shed some light please?

Question is not about number of conntrack entries in hash table, but
number of inserts and deletes per second.

=46or persistent connections, if you use a hash table of one million
slots, performance will be very good, since the chain length is small.
Its scalable because each cpu can access conntrack table without locks,
in parallel.

The real problem comes from serialization of inserts/deletes on a
central lock. Even with few entries (less than 50.000), this can be a
problem because its not scalable.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
