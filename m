From: "Anton VG" <anton.vazir@gmail.com>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 12:13:03 +0500
Message-ID: <c4b050a10804100013x56a10266h5ad6842686560b41@mail.gmail.com>
References: <200804091520.28617.anton.vazir@gmail.com>
	 <47FCA1F6.2000204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:7194 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYDJHNF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:13:05 -0400
Received: by mu-out-0910.google.com with SMTP id i10so3963298mue.5
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2008 00:13:04 -0700 (PDT)
In-Reply-To: <47FCA1F6.2000204@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

configure, created by autogen.sh generates the following error if
libnfnetlink is not installed.
(debian etch).

checking for socket... yes
checking for strerror... yes
./configure: line 20862: syntax error near unexpected token `LIBNFNETLINK,'
./configure: line 20862: `PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink
>= $LIBNFNETLINK_REQUIRED,,'


2008/4/9, Pablo Neira Ayuso <pablo@netfilter.org>:
> Anton wrote:
>  > Hello!
>  >
>  > A little question, regarding the current status of ULOGD2,
>  > and could it be used in the live accounting?
>  > Just trying to compile fresh SVN of ulog2 and noticed that
>  > lots of dependencies to fresh versions of NF libraries, and
>  > ULOG2 tries to compile MAC2STR, which does not exists in the
>  > ULOGD2 sources tree, so I had to remove it from Makefile to
>  > get it compiling.
>
>
> I forgot to commit the MAC2STR file. Please, refresh you SVN tree.
>
>
>  > Maybe ULOGD2 still is in deep development and not ready to
>  > any use yet?
>
>
> As you said, it's under development but any help in testing and
>  bugreporting would be great.
>
>
>  --
>  "Los honestos son inadaptados sociales" -- Les Luthiers
>
