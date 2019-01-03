From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 05/10] audit: add support for
 non-syscall auxiliary records
Date: Thu, 3 Jan 2019 15:10:59 -0500
Message-ID: <CAHC9VhSutzkgmUyp9NeWVL8CFpCgJ5XNTtj1SxOWHST-6oz+4g@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <2827530000d6b4972d446b0226adab153ff3b5c5.1533065887.git.rgb@redhat.com>
 <CAHC9VhSG3Hk2zrNP3w=CfEBXN7_LcywiTpvhGp48661xYhRq2A@mail.gmail.com> <20181101184853.vxel3dfdntzmhcnq@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com,
        dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101184853.vxel3dfdntzmhcnq@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 1, 2018 at 2:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
&gt; On 2018-10-19 19:17, Paul Moore wrote:
&gt; &gt; On Sun, Aug 5, 2018 at 4:33 AM Richard Guy Briggs
<rgb@redhat.com> wrote:
&gt; &gt; &gt; Standalone audit records have the timestamp and serial
number generated
&gt; &gt; &gt; on the fly and as such are unique, making them
standalone.  This new
&gt; &gt; &gt; function audit_alloc_local() generates a local audit
context that will
&gt; &gt; &gt; be used only for a standalone record and its auxiliary
record(s).  The
&gt; &gt; &gt; context is discarded immediately after the local
associated records are
&gt; &gt; &gt; produced.
&gt; &gt; &gt;
&gt; &gt; &gt; Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
&gt; &gt; &gt; Acked-by: Serge Hallyn <serge@hallyn.com>
&gt; &gt; &gt; ---
&gt; &gt; &gt;  include/linux/audit.h |  8 ++++++++
&gt; &gt; &gt;  kernel/audit.h        |  1 +
&gt; &gt; &gt;  kernel/auditsc.c      | 33 ++++++++++++++++++++++++++++-----
&gt; &gt; &gt;  3 files changed, 37 insertions(+), 5 deletions(-)
&gt; &gt;
&gt; &gt; I'm not in love with the local flag, and the whole local context in
&gt; &gt; general, but that's a larger discussion and not something I want to
&gt; &gt; force on this patchset; we can fix it later.
&gt;
&gt; I understand your reasoning to combine it so that if one patch gets
&gt; backported then both do, or if one gets reverted both do, but I really
&gt; prefer them seperate for similar reasons if there is more than one user.

The key is "more than one user".  As I mentioned below, assuming that
the only user is the networking bits (we can continue to discuss the
tty caller in the tty patch), this should live with the networking
bits; it makes no sense to keep it separate in that case.  Of course,
if there is more than one user, then keeping this change separate is
reasonable.

> > I think this patch looks fine, but it seems a bit odd standalone; it's
> > almost always better to include new capabilities/functions in the same
> > patch as the user.  Since the only user is the networking bits, it
> > might make more sense to fold this patch into that one.
>
> It was kept seperate due to tty_audit usage.  See my reasoning for patch
> 6, but I'm willing to negotiate if that merits an exception like the
> USER records do.

--
paul moore
www.paul-moore.com
