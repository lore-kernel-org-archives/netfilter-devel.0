From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables-save: add --chain argument, limits output to
 a chain
Date: Tue, 26 Feb 2013 16:40:47 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1302261639580.7776@nerf07.vanv.qr>
References: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com> <alpine.LNX.2.01.1302261547450.7232@nerf07.vanv.qr> <CABXqP=jq3rEE6b1xpgA0QtuwAQ04U5b3voMdTsuGmLB-qrsDxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jonh Wendell <jonh.wendell@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40630 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759194Ab3BZPkw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:40:52 -0500
In-Reply-To: <CABXqP=jq3rEE6b1xpgA0QtuwAQ04U5b3voMdTsuGmLB-qrsDxg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-02-26 15:57, Jonh Wendell wrote:
>2013/2/26 Jan Engelhardt <jengelh@inai.de>
>      On Tuesday 2013-02-26 12:33, jonh.wendell@gmail.com wrote:
>
>      >From: Jonh Wendell <jonh.wendell@oiwifi.com.br>
>      >
>      >Similar to the --table argument, if a --chain (or -C) argument
>      >is passed, we limit the output to rules of that chain.
>
>But we have `iptables -S chain` for that, don't we.
>
>
>I'm afraid its output is not suitable for iptables-restore.

I thought you just wanted to have a single chain shown, for the
purposes of debugging (because nobody can frankly read -L's output).
If however you want to feed it to replace, can you elaborate on your
use case? I would be interested in that.
