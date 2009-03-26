From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Updating variable shared between user and kernel space
Date: Thu, 26 Mar 2009 15:26:37 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903261504110.29211@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903260700y2908961ah2218fcd185a76f7f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36792 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbZCZO0k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:26:40 -0400
In-Reply-To: <17e3a8f80903260700y2908961ah2218fcd185a76f7f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-26 15:00, Kristian Evensen wrote:
>
>I have a value I would like to share between userspace and kernelspace
>(it is store in my target struct and intialized in the user space part
>of my module), but when I update it in kernel space it gets the wrong
>value. When for example incrementing the value by 1 every time the
>rule matches, the values are all messed up (but never larger than the
>number of matches/increments). When creating and initializing the
>value in the module, it behaves correctly.

See the "Writing Netfilter Modules" e-book rev March 26 2009,
section 4.6 "SMP problems". I just updated this because xt_quota,
which serves as an example, was changed recently to account for
the RCU patches, and so the explanation needed to change too.
