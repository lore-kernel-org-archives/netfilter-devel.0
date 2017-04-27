From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH next] iptables: on revision mismatch, do not call
 print/save
Date: Thu, 27 Apr 2017 13:47:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1704271340130.21876@blackhole.kfki.hu>
References: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com> <alpine.DEB.2.11.1704212202250.30178@blackhole.kfki.hu> <CAF=yD-+agqtwhkc+pQV+68K0pZiFZX13GcQZVR_Tv7SM_zkmZQ@mail.gmail.com> <CAF=yD-LkPtRVuUVmeOCJYaqmRCAKkPDkuxVV4QT_YsDOCfKpyg@mail.gmail.com>
 <CAF=yD-JSEfRFQWfKf+S_SzOkhYYhMgPYTzBmHO7J5iU47nFHrg@mail.gmail.com> <alpine.DEB.2.11.1704271114480.21354@blackhole.kfki.hu> <CA+FuTSfC+Wp+uZo4F+Z0R=OnM8929SZb+zAw3TgUyqUQyv-NZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, anubis@iwwd.com
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:54041 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754012AbdD0LrH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Apr 2017 07:47:07 -0400
In-Reply-To: <CA+FuTSfC+Wp+uZo4F+Z0R=OnM8929SZb+zAw3TgUyqUQyv-NZw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 27 Apr 2017, Willem de Bruijn wrote:

> > Maybe the case can be reproduced with the following steps, but I'm 
> > guessing:
> >
> > - rules inserted
> > - iptables binary downgraded/upgraded
> > - rules listed
> 
> It will. This is largely what the patch protects against. But perhaps
> it currently unnecessarily restricts binaries that support both
> revisions N and N + 1 from printing structs of rev N, if those
> are inserted from another binary that only supported up to N. Let
> me try that.
> 
> Before this patch, a rule inserted with a binary that only supports
> rev N for a given match, but read with another binary that supports
> rev N+1 will result in the new binary incorrectly parsing a struct of
> rev N as one of rev N + 1. And vice versa. See also the discussion in
> 
>   Re: [PATCH nf-next] netfilter: xt_bpf: support ebpf
>   https://www.spinics.net/lists/netfilter-devel/msg45357.html
> 
> Casting structs in this way is unsafe. The downgrade path cannot
> be fixed. But the upgrade path should. The way iptables negotiates
> with the kernel and only loads the highest revision for any given
> match or target may make this hard to change.

The downgrade case is OK and it is all right that iptables won't try to 
interpret the blob of the not supported revision and prints " [unsupported 
revision]" instead. But in the upgrade case iptables is able to print the 
target/match so it should do so.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
