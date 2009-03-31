From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Checkentry called twice?
Date: Tue, 31 Mar 2009 14:46:06 +0200
Message-ID: <17e3a8f80903310546h123f8esafda204cea519ecb@mail.gmail.com>
References: <17e3a8f80903310416w788a6379pb8184013a068c6a9@mail.gmail.com>
	 <17e3a8f80903310503r3fd630d6m7822f406e3694d9d@mail.gmail.com>
	 <alpine.LSU.2.00.0903311428080.14162@fbirervta.pbzchgretzou.qr>
	 <17e3a8f80903310532v44eadf72we077a301d1199aa9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46108 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbZCaMqJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:46:09 -0400
Received: by bwz17 with SMTP id 17so2350027bwz.37
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2009 05:46:06 -0700 (PDT)
In-Reply-To: <17e3a8f80903310532v44eadf72we077a301d1199aa9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for asking stupid questions, by reading some sections of the
book a bit more thorough I discovered that destroy is called after
checkentry :) Now I also understand why quota2 uses lists.

However, if there is a way to avoid replacing the table I am very
interested in learning about it.

-Kristian
