From: umesh sirsiwal <umesh31@gmail.com>
Subject: Fwd: tproxy and NAT incompatible?
Date: Fri, 6 Sep 2013 16:54:38 -0400
Message-ID: <CALk=bdaBVhDGAoC1L6Vmt4F2_V=vtrr8hAiRG84oAEherG=h+A@mail.gmail.com>
References: <CALk=bdYu4NNsXpjn8p3AcSYCdZT_3RaM_x0S22m+OBtZM26Vxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60718 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3IFUy6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:54:58 -0400
Received: by mail-vc0-f179.google.com with SMTP id ht10so2519858vcb.38
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2013 13:54:58 -0700 (PDT)
In-Reply-To: <CALk=bdYu4NNsXpjn8p3AcSYCdZT_3RaM_x0S22m+OBtZM26Vxg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
We have a unique situation. Our core application software needs to be
IP transparent. For this purpose it uses tproxy. When connecting to
upstream some of our client connections need to be SNATed.

This gives to the following situation:

As the client request arrives a conntrack is created that looks like:
IPa, Pa, IPb, Pb, IPa, Pa, IPb, Pb

As we connect out to the origin a new conntrack entry is created that
looks like:
IPa, Pa', IPb, Pb, NAT-IPa, NAT-Pa, IPb, Pb

With some probability an independent incoming request may look like:
IPa, Pa', IPb, Pb

We see that as SYN with this request arrives, the old NAT conntrack
entry is removed blackholing the upstream connection.

Can tproxy be safely used with SNAT? Is there a way around this issue?


-Umesh





-- 
Homepage: http://blogs.techievarta.com/
