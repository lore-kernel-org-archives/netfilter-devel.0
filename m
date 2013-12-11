From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [PATCH ulogd] ulogd: use AC_SEARCH_LIBS for libpthread
Date: Tue, 10 Dec 2013 21:56:19 -0300
Message-ID: <52A7B833.3040309@zacarias.com.ar>
References: <1386678252-6853-1-git-send-email-gustavo@zacarias.com.ar> <1386722770.4710.3.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:38171 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3LKA4c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:56:32 -0500
In-Reply-To: <1386722770.4710.3.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/10/2013 09:46 PM, Eric Leblond wrote:

> Is there some need for this type of systems to have access to the
> database backends ? In this case, it will be interesting to make
> conditional the build of the new thread running mode.

My $.02 say no, it's probably not worth the effort, such a system would
probably be resourceful (not memory/storage constrained) and just be
able to use a threaded libc (an ARM uClibc libpthread is ~68 KiB stripped).
Regards.

