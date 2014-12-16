From: Florian Westphal <fw@strlen.de>
Subject: Re: Hook on non standard protocol families
Date: Tue, 16 Dec 2014 09:19:48 +0100
Message-ID: <20141216081948.GA24756@breakpoint.cc>
References: <CAHL=LFCW6aTm-qBm6T17p7eXAkYDNJcmXA+dG0kuK+-ry5RCPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Yaron Galula <ygalula@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56171 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbaLPITu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:19:50 -0500
Content-Disposition: inline
In-Reply-To: <CAHL=LFCW6aTm-qBm6T17p7eXAkYDNJcmXA+dG0kuK+-ry5RCPA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yaron Galula <ygalula@gmail.com> wrote:
> I'd like to try and hook some non standard protocol families, such as
> PF_CAN for example.
>
> Is that possible?

No.

> I have tried using nf_register_hook() with NFPROTO_UNSPEC hoping it
> will act as a wildcard, but the module I have built and loaded does
> not seem to be in use (it does work when I replace NFPROTO_UNSPEC with
> PF_INET).

Sure, because ipv4 core calls that via NF_HOOK() at various places.

> I would really appreciate your help in making this work.

At the very least you need to change the CAN core to call
netfilter hooks at the right places.

Look at ipv4 or ipv6 as a template.
