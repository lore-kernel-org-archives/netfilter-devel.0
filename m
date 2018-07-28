From: Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH 00/18] xfrm: Add compat layer
Date: Sat, 28 Jul 2018 17:26:55 +0100
Message-ID: <1532795215.2679.27.camel@arista.com>
References: <20180726023144.31066-1-dima@arista.com>
         <20180726084959.pzjvflfjq6a76du6@breakpoint.cc>
         <20180727073747.h27dtojlnmc3k25v@gauss3.secunet.de>
         <1532700173.2679.18.camel@arista.com>
         <20180727141936.uze6ohordx7ue3no@breakpoint.cc>
         <1532703111.2679.20.camel@arista.com>
         <CADhJOfam+cY8uD4XTGvZSEFQdAgTu49G6cg6c64NJoP3bNuBmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Safonov <0x7f454c46@gmail.com>, netdev@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-efi@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfou
To: Nathan Harold <nharold@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADhJOfam+cY8uD4XTGvZSEFQdAgTu49G6cg6c64NJoP3bNuBmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2018-07-27 at 09:48 -0700, Nathan Harold wrote:
> We (Android) are very interested in removing the restriction for 32-
> bit userspace processes accessing xfrm netlink on 64-bit kernels.
> IPsec support is required to pass Android conformance tests, and any
> manufacturer wishing to ship 32-bit userspace with a recent kernel
> needs out-of-tree changes (removing the compat_task check) to do so.

Glad to hear - that justify my attempts more :)

> That said, it’s not difficult to work around alignment issues
> directly in userspace, so maybe we could just remove the check and
> make this the caller's responsibility? Here’s an example of the
> workaround currently in the Android tree:
> https://android.googlesource.com/platform/system/netd/+/refs/heads/ma
> ster/server/XfrmController.h#257

We've kinda same workarounds in our userspace..
But I don't think reverting the check makes much sense - it'll make
broken compat ABI in stone.
If you're fine with disgraceful hacks and just want to get rid of
additional non-mainstream patch - you can make 64-bit syscalls from 32-
bit task (hint: examples in x86 selftests).


> We could also employ a (relatively simple) solution such as the one
> above in the uapi XFRM header itself, though it would require a
> caller to declare the target kernel ABI at compile time. Maybe that’s
> not unthinkable for an uncommon case?

Well, I think, I'll rework my patches set according to critics and
separate compat xfrm layer. I've already a selftest to check that 32/64
bit xfrm works - so the most time-taking part is done.
So, if you'll wait a week or two - you may help me to justify acception
of mainstreaming those patches.

> On Fri, Jul 27, 2018 at 7:51 AM, Dmitry Safonov <dima@arista.com>
> wrote:
> > On Fri, 2018-07-27 at 16:19 +0200, Florian Westphal wrote:
> > > Dmitry Safonov <dima@arista.com> wrote:
> > > > 1. It will double copy netlink messages, making it O(n) instead
> > of
> > > > O(1), where n - is number of bind()s.. Probably we don't care
> > much.
> > > 
> > > About those bind() patches, I don't understand why they are
> > needed.
> > > 
> > > Why can't you just add the compat skb to the native skb when
> > doing
> > > the multicast call?
> > > 
> > > skb_shinfo(skb)->frag_list = compat_skb;
> > > xfrm_nlmsg_multicast(net, skb, 0, ...
> > 
> > Oh yeah, sorry, I think I misread the patch - will try to add
> > compat
> > skb in the multicast call.
> > 

-- 
Thanks,
             Dmitry
