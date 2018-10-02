From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 15:22:03 -0700
Message-ID: <CAHo-OoyWVNfhYBvGoXEScL+b-nz4jr_wJZ5u5aOfD3HM9eTO=A@mail.gmail.com>
References: <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181002075903.3wpgej3j6dttbqck@salvia> <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
 <20181002101119.tyljwzqpdj7qoe6f@salvia> <20181002101556.lpvn4kz7xgv2at3f@salvia>
 <CANP3RGf4pnPYiLoLNqULz-ELUT18qDctmi3kUw6qpkppwtcXmg@mail.gmail.com>
 <20181002105125.uv7mcitvaalpjueo@salvia> <CAMOXUJkYwz-aOuWO4ygVchTVWiX59=3znCb-NWC55nsmHSD93A@mail.gmail.com>
 <20181002181546.b6zhizcl6lj2inu2@salvia> <CAMOXUJn6c+ybxks9siDn=fJo4mGBYk88LuD17BYnPBAPySufDg@mail.gmail.com>
 <20181002184357.3hd5g3kskj57qjlw@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Chenbo Feng <fengc@google.com>,
        Chenbo Feng <chenbofeng.kernel@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist
        <netfilter-devel@vger.kernel.org>, kernel-team@android.com,
        Lorenzo Colitti <lorenzo@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181002184357.3hd5g3kskj57qjlw@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Could you clarify what exact behaviour Willem removed?

On Tue, Oct 2, 2018 at 11:43 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 02, 2018 at 11:28:21AM -0700, Chenbo Feng wrote:
>> On Tue, Oct 2, 2018 at 11:15 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >
>> > Hi Chenbo,
>> >
>> > On Tue, Oct 02, 2018 at 10:45:58AM -0700, Chenbo Feng wrote:
>> > > On Tue, Oct 2, 2018 at 3:51 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > [...]
>> > > Do you mean the remain field will be zeroed when copying the
>> > > xt_quota_info struct out of the kernel? I believe that is decided by
>> > > the usersize defined in struct xt_match and this patch set it to the
>> > > full struct size. So the whole xt_quota_info struct will be copied
>> > > into userspace including the field stores the remaining quota. The
>> > > userspace will not be aware of it if the ipatbles is not updated but
>> > > it should not modify it as well. I have tested the behavior with
>> > > net-next branch and it seems working. Am I missing something
>> > > recently updated?
>> >
>> > Hm, I see, I overlook that your patch removes this:
>> >
>> > -       .usersize   = offsetof(struct xt_quota_info, master),
>> >
>> > BTW, is iptables -D command working with your patch?
>> >
>> > Telling this because if .usersize is removed, then IIRC userspace
>> > compares this new remain field with userspace value and deletion will
>> > break.
>> >
>> > Patch that I was referring before is this one from Willem:
>> >
>> > commit f32815d21d4d8287336fb9cef4d2d9e0866214c2
>> > Author: Willem de Bruijn <willemb@google.com>
>> > Date:   Mon Jan 2 17:19:40 2017 -0500
>> >
>> >     xtables: add xt_match, xt_target and data copy_to_user functions
>> >
>> >     xt_entry_target, xt_entry_match and their private data may contain
>> >     kernel data.
>> > [...]
>> >     Private data is defined in xt_match and xt_target. All matches and
>> >     targets that maintain kernel data store this at the tail of their
>> >     private structure. Extend xt_match and xt_target with .usersize to
>> >     limit how many bytes of data are copied. The remainder is cleared.
>> >
>> > Let me know, thanks !
>>
>> The delete operation is decided by the userspacesize defined in
>> userspace ipatbles. I think it is unrelated to the usersize we talk
>> about here. For old userspace iptables, the userspacesize is
>> offsetof(struct xt_quota_info, master) so it will not compare the rest
>> if the struct. And for new iptables we use offsetof(struct
>> xt_quota_info, remain). Either way the userspace does not consider the
>> remain field when comparing rules so we can do ipatbles rule deletion
>> with or without specifying --remain option or even specify --remain to
>> a wrong number. We decide to make it this way since the --remain field
>> is changing all the time when there is network traffic going on and
>> it's hard to compare the remaining quota for new ipatbles as well.
>
> Thanks for explaining and your patience. Patch looks good then.
>
> Thanks!
