From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 20:15:46 +0200
Message-ID: <20181002181546.b6zhizcl6lj2inu2@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
 <20181002075903.3wpgej3j6dttbqck@salvia>
 <CANP3RGeo71YYqPENVkEC_XzS+44ANQ9gLV2eX=aZbuc6TMuTAQ@mail.gmail.com>
 <20181002101119.tyljwzqpdj7qoe6f@salvia>
 <20181002101556.lpvn4kz7xgv2at3f@salvia>
 <CANP3RGf4pnPYiLoLNqULz-ELUT18qDctmi3kUw6qpkppwtcXmg@mail.gmail.com>
 <20181002105125.uv7mcitvaalpjueo@salvia>
 <CAMOXUJkYwz-aOuWO4ygVchTVWiX59=3znCb-NWC55nsmHSD93A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zenczykowski@gmail.com, Chenbo Feng <chenbofeng.kernel@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>
To: Chenbo Feng <fengc@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMOXUJkYwz-aOuWO4ygVchTVWiX59=3znCb-NWC55nsmHSD93A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Chenbo,

On Tue, Oct 02, 2018 at 10:45:58AM -0700, Chenbo Feng wrote:
> On Tue, Oct 2, 2018 at 3:51 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> Do you mean the remain field will be zeroed when copying the
> xt_quota_info struct out of the kernel? I believe that is decided by
> the usersize defined in struct xt_match and this patch set it to the
> full struct size. So the whole xt_quota_info struct will be copied
> into userspace including the field stores the remaining quota. The
> userspace will not be aware of it if the ipatbles is not updated but
> it should not modify it as well. I have tested the behavior with
> net-next branch and it seems working. Am I missing something
> recently updated?

Hm, I see, I overlook that your patch removes this:

-       .usersize   = offsetof(struct xt_quota_info, master),

BTW, is iptables -D command working with your patch?

Telling this because if .usersize is removed, then IIRC userspace
compares this new remain field with userspace value and deletion will
break.

Patch that I was referring before is this one from Willem:

commit f32815d21d4d8287336fb9cef4d2d9e0866214c2
Author: Willem de Bruijn <willemb@google.com>
Date:   Mon Jan 2 17:19:40 2017 -0500

    xtables: add xt_match, xt_target and data copy_to_user functions

    xt_entry_target, xt_entry_match and their private data may contain
    kernel data.
[...]
    Private data is defined in xt_match and xt_target. All matches and
    targets that maintain kernel data store this at the tail of their
    private structure. Extend xt_match and xt_target with .usersize to
    limit how many bytes of data are copied. The remainder is cleared.

Let me know, thanks !
