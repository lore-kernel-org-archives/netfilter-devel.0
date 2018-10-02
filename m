From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 12:15:56 +0200
Message-ID: <20181002101556.lpvn4kz7xgv2at3f@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181002075903.3wpgej3j6dttbqck@salvia>
 <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
 <20181002101119.tyljwzqpdj7qoe6f@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>,
        Chenbo Feng <fengc@google.com>,
        Maciej Zenczykowski <maze@google.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181002101119.tyljwzqpdj7qoe6f@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 02, 2018 at 12:11:19PM +0200, Pablo Neira Ayuso wrote:
> Hi Maciej!
> 
[...]
> On Tue, Oct 02, 2018 at 01:24:29AM -0700, Maciej Żenczykowski wrote:
> > > I guess problem is userspace may get a current counter that is larger
> > > than the quota, but we could handle this from userspace iptables to
> > > print a value that equals the quota, ie. from userspace, before
> > > printing:
> > 
> > I'm not sure what you mean.
> 
> I mean: Instead of using atomic64_set() to set the counter to 1 once
> we went over quota,

incomplete sentence, sorry:

I mean: Instead of using atomic64_set() to set the counter to 1 once
we go overquota, we just keep updating 'consumed' bytes.

ie. we don't express things in 'remaining bytes' logic, but we account
for 'bytes we already consumed'. So we never go negative - I know
understand what you mean about -1... I think we are each other
thinking from our respective approach proposal.

:-)

Thanks!
