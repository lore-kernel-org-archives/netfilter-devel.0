From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Correct signatur for target
Date: Tue, 24 Mar 2009 14:21:54 +0100
Message-ID: <17e3a8f80903240621ic1a86f0gac018b02cd0fa9da@mail.gmail.com>
References: <17e3a8f80903240606v1efab2eds2a40a1dbe820af00@mail.gmail.com>
	 <alpine.LSU.2.00.0903241410130.27859@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47335 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbZCXNV5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:21:57 -0400
Received: by fxm2 with SMTP id 2so2270618fxm.37
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2009 06:21:54 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903241410130.27859@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> To make Xtables-addons's compat_xtables.ko work with all supported
> kernel versions, it has to slightly deviate from the latest kernel
> API and use a double-pointer. So if you write your module with the
> help of the compat layer, you need to be aware of this minor
> difference. I think the latest version of the e-book also mentions
> this.

Thank you very much. When I no longer included "compat_xtables.h" and
changed the signature, it worked.

When I read the related paragraph (second in section 5.2) in the book
again now, I see that it is mentioned. However, since I am not so
familiar with xtables, I did not connect "glue code" with the
"compat_xtables.h".

Thank you again,
Kristian
