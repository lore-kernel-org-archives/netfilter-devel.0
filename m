From: Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH 00/18] xfrm: Add compat layer
Date: Fri, 27 Jul 2018 15:02:53 +0100
Message-ID: <1532700173.2679.18.camel@arista.com>
References: <20180726023144.31066-1-dima@arista.com>
         <20180726084959.pzjvflfjq6a76du6@breakpoint.cc>
         <20180727073747.h27dtojlnmc3k25v@gauss3.secunet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
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
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Shuah Khan <shua
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180727073747.h27dtojlnmc3k25v@gauss3.secunet.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2018-07-27 at 09:37 +0200, Steffen Klassert wrote:
> On Thu, Jul 26, 2018 at 10:49:59AM +0200, Florian Westphal wrote:
> > Dmitry Safonov <dima@arista.com> wrote:
> > > So, here I add a compatible layer to xfrm.
> > > As xfrm uses netlink notifications, kernel should send them in
> > > ABI
> > > format that an application will parse. The proposed solution is
> > > to save the ABI of bind() syscall. The realization detail is
> > > to create kernel-hidden, non visible to userspace netlink groups
> > > for compat applications.
> > 
> > Why not use exisiting netlink support?
> > Just add the 32bit skb to skb64->frag_list and let
> > netlink find if tasks needs 64 or 32 one.
> > 
> > It only needs this small fix to properly signal the end of a dump:
> > https://marc.info/?l=linux-netdev&m=126625240303351&w=2
> > 
> > I had started a second attempt to make xfrm compat work,
> > but its still in early stage.
> > 
> > One link that might still have some value:
> > https://git.breakpoint.cc/cgit/fw/net-next.git/commit/?h=xfrm_confi
> > g_compat_07&id=f64430e6d9e297f3990f485a4832e273751b9869
> > (compat structure definitions with BUILD_BUG_ON checking)
> > 
> > My plan was to make xfrm compat work strictly as shrinker (64->32)
> > and expander (32->64), i.e. no/little changes to exisiting code and
> > pass all "expanded" skbs through existing xfrm rcv functions.
> 
> I agree here with Florian. The code behind this ABI
> is already complicated. Please stay away from generic
> code a much as possible. Generic and compat code should
> be clearly separated.

Yeah, I tend to agree that it would be better to separate it.
But:
1. It will double copy netlink messages, making it O(n) instead of
O(1), where n - is number of bind()s.. Probably we don't care much.
2. The patches not-yet-done on the link have +500 added lines - as much
as my working patches set, so probably it'll add more code.

Probably, we don't care that much about amount of code added and
additional copies than about separating compat layer from the main
code. Will look into that.

-- 
Thanks,
             Dmitry
