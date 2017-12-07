From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the vfs tree with the netfilter
 tree
Date: Thu, 7 Dec 2017 13:46:09 +1100
Message-ID: <20171207134609.6a3e5424@canb.auug.org.au>
References: <20171207111035.7c22d7c0@canb.auug.org.au>
        <CAG48ez1itzyi=0_N-DfjJ+LYSTjCkQR-GHNLOSTnR=oOj7nyyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jann Horn <jannh@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1itzyi=0_N-DfjJ+LYSTjCkQR-GHNLOSTnR=oOj7nyyQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jann,

On Thu, 7 Dec 2017 01:48:14 +0100 Jann Horn <jannh@google.com> wrote:
>
> > I can't tell if the strlen test from the former is still needed, so I
> > just used the vfs tree version for now.  
> 
> Yeah, both of the checks from the netfilter tree are still necessary
> independent of the commit from the vfs tree.

Rats.  I will see what I can do about that.

> > I fixed it up (see below)  
> 
> Did you mean to paste in the fixed-up patch below this message?

Ah, well actually the diff ended up empty (since I used one side of the
conflicting part).
-- 
Cheers,
Stephen Rothwell
