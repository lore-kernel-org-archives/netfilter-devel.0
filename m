From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 12:52:20 +0200
Message-ID: <20181002105220.yyof3qxfege5o6ic@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181002075903.3wpgej3j6dttbqck@salvia>
 <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
 <20181002101119.tyljwzqpdj7qoe6f@salvia>
 <20181002101556.lpvn4kz7xgv2at3f@salvia>
 <CANP3RGf4pnPYiLoLNqULz-ELUT18qDctmi3kUw6qpkppwtcXmg@mail.gmail.com>
 <20181002105125.uv7mcitvaalpjueo@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>,
        Chenbo Feng <fengc@google.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181002105125.uv7mcitvaalpjueo@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 02, 2018 at 12:51:25PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 02, 2018 at 03:38:24AM -0700, Maciej Żenczykowski wrote:
> > > Well, you will need a kernel + userspace update anyway, right?
> > 
> > It's true you need new iptables userspace to *see* during dump and/or
> > manually *set* during restore the remain counter.
> > 
> > However, (and I believe Chenbo tested this) just a new kernel is
> > enough to fix the problem of modifications within the table resetting
> > the counter.
> > This is because the data gets copied out of kernel and back into
> > kernel by old iptables without any further modifications.
> > ie. the new kernel not clearing the field on copy to userspace and
> > honouring it on copy to kernel is sufficient.
> 
> I see, Willem removed this behaviour in newer kernels. The private
> area is now zeroed, is that what you mean right? So I guess this
> cannot be done transparently.
> 
> Anyway, I think the --remain approach to fix this longstanding
> problem from iptables :-).

Argh, broken sentence: I mean, I think it's the way to go for
iptables.
