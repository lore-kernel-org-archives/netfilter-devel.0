From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: build warning after merge of the netfilter-next tree
Date: Tue, 15 May 2018 12:54:22 +0200
Message-ID: <CAMuHMdU0iUBbkPL5ZKxKuORnQA9ujX1J+5NLw=ft80hJh20VxQ@mail.gmail.com>
References: <20180507105519.1d34f19e@canb.auug.org.au> <20180508102101.768d5c52@canb.auug.org.au>
 <20180508071756.grie5wln2lpo52un@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508071756.grie5wln2lpo52un@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Florian,

On Tue, May 8, 2018 at 9:17 AM, Florian Westphal <fw@strlen.de> wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> On Mon, 7 May 2018 10:55:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> > After merging the netfilter-next tree, today's linux-next build (x86_64
>> > allmodconfig) produced this warning:
>> >
>> > ./usr/include/linux/netfilter/nf_osf.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>
>>
>> > Introduced by commit
>> >
>> >   bfb15f2a95cb ("netfilter: extract Passive OS fingerprint infrastructure from xt_osf")
>
> I'll send a fix for this, thanks for reporting.

+config NF_OSF
+       tristate 'Passive OS fingerprint infrastructure'

"There is no help available for this option."

Is this meant to be a user-visible symbol?
I noticed it is selected by NETFILTER_XT_MATCH_OSF.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
