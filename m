From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: hash_netnet4_data_equal typo commit status follow-up
Date: Mon, 6 Jan 2014 20:40:18 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1401062038560.18755@blackhole.kfki.hu>
References: <CADrOd4ATEkknSRonuuS5me-UraJaoK+UaBd68D_Q4nnQ0oMD-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Gervais <dgervais@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:38264 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbaAFTkX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:40:23 -0500
In-Reply-To: <CADrOd4ATEkknSRonuuS5me-UraJaoK+UaBd68D_Q4nnQ0oMD-w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 6 Jan 2014, David Gervais wrote:

> I noticed that the following commit has not yet been synchronized into
> the main ipset git repo and requires pulling. The commit currently
> exists in Pablo's netfilter repo, David Miller's repo, and in Linus's
> 3.14 RC repo.
> 
> netfilter: ipset: fix incorret comparison in hash_netnet4_data_equal()
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b49faea7655ec10ade15d7d007e4218ca578a513
> 
> Since the original fix was submitted on November 25th and still has
> yet to be applied to the main ipset git repo, I figured I would
> follow-up regarding its status and to make sure it wasn't lost.

I forgot to push my tree... now it's done, thanks for the notification.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
