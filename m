From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 03:38:24 -0700
Message-ID: <CANP3RGf4pnPYiLoLNqULz-ELUT18qDctmi3kUw6qpkppwtcXmg@mail.gmail.com>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181002075903.3wpgej3j6dttbqck@salvia> <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
 <20181002101119.tyljwzqpdj7qoe6f@salvia> <20181002101556.lpvn4kz7xgv2at3f@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>,
        Chenbo Feng <fengc@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181002101556.lpvn4kz7xgv2at3f@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> Well, you will need a kernel + userspace update anyway, right?

It's true you need new iptables userspace to *see* during dump and/or
manually *set* during restore the remain counter.

However, (and I believe Chenbo tested this) just a new kernel is
enough to fix the problem of modifications within the table resetting
the counter.
This is because the data gets copied out of kernel and back into
kernel by old iptables without any further modifications.
ie. the new kernel not clearing the field on copy to userspace and
honouring it on copy to kernel is sufficient.

So iptables-save | iptables-restore doesn't work, but iptables -A foo does.

(currently iptables -t X -{A,D} foo clears all xt_quota counters in
table X even when foo is utterly unrelated)

>> I mean: Instead of using atomic64_set() to set the counter to 1 once
>> we went over quota,
>
> incomplete sentence, sorry:
>
> I mean: Instead of using atomic64_set() to set the counter to 1 once
> we go overquota, we just keep updating 'consumed' bytes.

I guess it's a fair point that with a u64 we won't ever realistically
overflow the number of sent bytes, so this could be a running counter
of matched bytes...

and we don't even need to update it if it was over the quota when we
first looked at it, so we'll go over by at most # of cpus * max size
of gso packet bytes.

> ie. we don't express things in 'remaining bytes' logic, but we account
> for 'bytes we already consumed'. So we never go negative - I know
> understand what you mean about -1... I think we are each other
> thinking from our respective approach proposal.

I guess our decision was probably driven by xt_quota2 use on android
where infinite quota is often used as a temporary placeholder.
