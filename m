From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Updating variable shared between user and kernel space
Date: Thu, 26 Mar 2009 16:29:41 +0100
Message-ID: <17e3a8f80903260829j38f5af65v57005a3f8ffd542b@mail.gmail.com>
References: <17e3a8f80903260700y2908961ah2218fcd185a76f7f@mail.gmail.com>
	 <alpine.LSU.2.00.0903261504110.29211@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43317 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZCZP3o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:29:44 -0400
Received: by fxm2 with SMTP id 2so610023fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 08:29:41 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903261504110.29211@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> See the "Writing Netfilter Modules" e-book rev March 26 2009,
> section 4.6 "SMP problems". I just updated this because xt_quota,
> which serves as an example, was changed recently to account for
> the RCU patches, and so the explanation needed to change too.

Thank you, that was the chapter I was using a reference. Kmalloc here I come.

-Kristian
