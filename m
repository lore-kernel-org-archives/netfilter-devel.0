From: Doug Anderson <dianders@chromium.org>
Subject: Re: [RFC/PATCH 2/3] netfilter: ctnetlink: Fix regression in
 CTA_STATUS processing
Date: Wed, 18 Jan 2017 11:02:10 -0800
Message-ID: <CAD=FV=UJ+-M8XmX00ZR048dog126QX+nVmpM9vM8rVz90DF30Q@mail.gmail.com>
References: <1484630048-25416-1-git-send-email-cernekee@chromium.org> <1484630048-25416-3-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484630048-25416-3-git-send-email-cernekee@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, Jan 16, 2017 at 9:14 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
> The libnetfilter_conntrack userland library always sets IPS_CONFIRMED
> when building a CTA_STATUS attribute.  If this toggles the bit from
> 0->1, Linux 4.4+ will reject it and this will cause any NFQA_EXP
> attribute in the packet to be ignored.  This breaks conntrackd's
> userland helpers because they operate on unconfirmed connections.

I prefer the wording that you changed it to between this patch and the
next one on the Chromium OS review system:

https://chromium-review.googlesource.com/c/428493/1..2//COMMIT_MSG

It makes it more obvious that the function has always considered some
of these things to be "errors" but that the errors simply affect
things so much in the past (before commit b7bd1809e078 ("netfilter:
nfnetlink_queue: get rid of nfnetlink_queue_ct.c")).

> Instead of returning -EBUSY if the user program asks to modify an
> unchangeable bit, simply ignore the change.
>
> Also, fix the logic so that user programs are allowed to clear
> the bits that they are allowed to change.

This is a general bugfix to the code.  If folks are using netfilter
then it seems like this ought to be backported even before 4.4.


> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>  include/uapi/linux/netfilter/nf_conntrack_common.h |  4 ++++
>  net/netfilter/nf_conntrack_netlink.c               | 10 ++++------
>  2 files changed, 8 insertions(+), 6 deletions(-)

This bugfix is fairly easy to understand.  Assuming you agree that
it's OK to silently ignore these errors (and behave more like things
worked before kernel 4.4), then it's a clear win.

Unless someone has a better suggestion, I'd say:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
