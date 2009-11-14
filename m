From: Justin Yaple <yaplej@gmail.com>
Subject: Moving sk_buff manipulation to userspace?
Date: Fri, 13 Nov 2009 23:24:18 -0800
Message-ID: <8363055a0911132324sbc60466h1c8f45fddf48b21a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:49328 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZKNHYM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2009 02:24:12 -0500
Received: by ywh40 with SMTP id 40so1923762ywh.33
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2009 23:24:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greetings,

I have finished a prototype for a WAN accelerator that users netfilter
hooks to intercept packets that are being forwarded.=A0 It then does
some checks, and potentially compresses the TCP data segment using an
LZ compression method.=A0 Pretty neat stuff you guys have done here.

I would like to do more than strictly compressing the data, but due to
the netfilter hook running in an interrupt context I am quite limited.
 So I found that using NF_QUEUE its possible to move processing to a
userspace process.

Will moving the processing to a userspace application prevent me from
directly modifying the sk_buff though?=A0 Particularly I need to
maintain the capability of modifying the TCP data segment, and TCP
header section.=A0 I was looking at the example
trunk/libnetfilter_queue/utils/nfqnl_test.c, but there is nothing in
there about how to manipulate the sk_buff once its been received.=A0 Is
this even possible using the NF_QUEUE?

Thanks,
Jusitn.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
