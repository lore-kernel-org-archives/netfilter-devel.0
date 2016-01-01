From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset v6.24: Comment string is too long!
Date: Fri, 1 Jan 2016 23:39:57 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1601012338430.12801@blackhole.kfki.hu>
References: <CAJiejCQizhn--05MnVzKFLyEFki=K6xzJbL+_b7yVgxYKYmitA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: maillist-netfilter <netfilter-devel@vger.kernel.org>
To: Drunkard Zhang <gongfan193@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:43744 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbcAAWjv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jan 2016 17:39:51 -0500
In-Reply-To: <CAJiejCQizhn--05MnVzKFLyEFki=K6xzJbL+_b7yVgxYKYmitA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, 30 Dec 2015, Drunkard Zhang wrote:

>     I'm trying ipset, and misleaded by the error message: "ipset
> v6.24: Comment string is too long!", when doing this:
> 
> 15:26:34 ~ # ipset create bypass hash:net
> 15:26:40 ~ # ipset add bypass 42.62.0.0/16 comment "cnc"
> ipset v6.24: Comment string is too long!
> 
> it took me some time to identify where the problem is: "comment"
> extension should be enabled when creating the set.
> 
> So, WOULD YOU PLEASE replace these words with more accurate sentence?
> In this situation, say "'comment' extension not enabled", others say
> "Comment string is too long!".
> 
> Or, emphasize/highlight "extensions must be enabled before use" in man page.

I'll look into it - I mean both, i.e. better error message and updated 
manpage :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
