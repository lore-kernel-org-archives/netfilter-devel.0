From: Chenbo Feng <fengc@google.com>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 10:45:58 -0700
Message-ID: <CAMOXUJkYwz-aOuWO4ygVchTVWiX59=3znCb-NWC55nsmHSD93A@mail.gmail.com>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181002075903.3wpgej3j6dttbqck@salvia> <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
 <20181002101119.tyljwzqpdj7qoe6f@salvia> <20181002101556.lpvn4kz7xgv2at3f@salvia>
 <CANP3RGf4pnPYiLoLNqULz-ELUT18qDctmi3kUw6qpkppwtcXmg@mail.gmail.com> <20181002105125.uv7mcitvaalpjueo@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: zenczykowski@gmail.com, Chenbo Feng <chenbofeng.kernel@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181002105125.uv7mcitvaalpjueo@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 2, 2018 at 3:51 AM Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
>
> On Tue, Oct 02, 2018 at 03:38:24AM -0700, Maciej =C5=BBenczykowski wrote:
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
Sorry, resend in plain text mode.

Do you mean the remain field will be zeroed when copying the
xt_quota_info struct out of the kernel? I believe that is decided by
the usersize defined in struct xt_match and this patch set it to the
full struct size. So the whole xt_quota_info struct will be copied
into userspace including the field stores the remaining quota. The
userspace will not be aware of it if the ipatbles is not updated but
it should not modify it as well. I have tested the behavior with
net-next branch and it seems working. Am I missing something recently
updated?
> Anyway, I think the --remain approach to fix this longstanding
> problem from iptables :-).
>
> > So iptables-save | iptables-restore doesn't work, but iptables -A foo d=
oes.
> >
> > (currently iptables -t X -{A,D} foo clears all xt_quota counters in
> > table X even when foo is utterly unrelated)
> >
> > >> I mean: Instead of using atomic64_set() to set the counter to 1 once
> > >> we went over quota,
> > >
> > > incomplete sentence, sorry:
> > >
> > > I mean: Instead of using atomic64_set() to set the counter to 1 once
> > > we go overquota, we just keep updating 'consumed' bytes.
> >
> > I guess it's a fair point that with a u64 we won't ever realistically
> > overflow the number of sent bytes, so this could be a running counter
> > of matched bytes...
> >
> > and we don't even need to update it if it was over the quota when we
> > first looked at it, so we'll go over by at most # of cpus * max size
> > of gso packet bytes.
> >
> > > ie. we don't express things in 'remaining bytes' logic, but we accoun=
t
> > > for 'bytes we already consumed'. So we never go negative - I know
> > > understand what you mean about -1... I think we are each other
> > > thinking from our respective approach proposal.
> >
> > I guess our decision was probably driven by xt_quota2 use on android
> > where infinite quota is often used as a temporary placeholder.
>
> I see, thanks for explaining.
>
> Thanks.
