From: Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH 00/18] xfrm: Add compat layer
Date: Fri, 27 Jul 2018 15:51:51 +0100
Message-ID: <1532703111.2679.20.camel@arista.com>
References: <20180726023144.31066-1-dima@arista.com>
         <20180726084959.pzjvflfjq6a76du6@breakpoint.cc>
         <20180727073747.h27dtojlnmc3k25v@gauss3.secunet.de>
         <1532700173.2679.18.camel@arista.com>
         <20180727141936.uze6ohordx7ue3no@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Cheh
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180727141936.uze6ohordx7ue3no@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2018-07-27 at 16:19 +0200, Florian Westphal wrote:
> Dmitry Safonov <dima@arista.com> wrote:
> > 1. It will double copy netlink messages, making it O(n) instead of
> > O(1), where n - is number of bind()s.. Probably we don't care much.
> 
> About those bind() patches, I don't understand why they are needed.
> 
> Why can't you just add the compat skb to the native skb when doing
> the multicast call?
> 
> skb_shinfo(skb)->frag_list = compat_skb;
> xfrm_nlmsg_multicast(net, skb, 0, ...

Oh yeah, sorry, I think I misread the patch - will try to add compat
skb in the multicast call.

-- 
Thanks,
             Dmitry
