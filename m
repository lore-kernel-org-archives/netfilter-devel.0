From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: build issues
Date: Tue, 24 Mar 2009 20:02:03 +0100
Message-ID: <49C92E2B.3030906@trash.net>
References: <20090324185711.GB2551@jukie.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Bart Trojanowski <bart@jukie.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41529 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZCXTCR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:02:17 -0400
In-Reply-To: <20090324185711.GB2551@jukie.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've CCed netfilter-devel since I assume more people will hit this.

Bart Trojanowski wrote:
> the project sounds very interesting.  I wanted to give it a try -- at
> least look at the user space for now -- but I ran into some build
> issues.
> 
> Here is what I ran:
> 
> ...
> Up to here everything works nicely, but then...
> 
>         % cd ../nftables
>         % LIBS=-L${HOME}/usr/lib CFLAGS=-I${HOME}/usr/include ./configure --prefix=${HOME}/usr
>         % make install
> 
>           SUBDIR    src/
>           LEX       src/scanner.l
>           DEP       src/scanner.c
>           YACC      src/parser.y
>         src/parser.y: fatal error: invalid @ in skeleton: @output 

I assume you're using a recent version of Debian unstable?

The nftables tree includes a copy of the bison template for debugging
purposes because there's no other way to increase the amount of expected
tokens reported during an syntax error. The current bison version used
in Debian unstable is incompatible with the old templates. I've tried
updating the template, but the bison version appears to be broken
itself and incorrectly jumps into the lexer after an EOF again, causing
a crash. For now I'd recommend to get an older version of bison to
compile nftables. 1.2.3.dfsg-4 from etch works fine for me.

