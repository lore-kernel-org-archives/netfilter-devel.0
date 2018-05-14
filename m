From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak81 RFC V2 3/5] audit: use inline function to get audit context
Date: Mon, 14 May 2018 17:44:01 -0400
Message-ID: <CAHC9VhQXr76FXPCe8vUWNwa2VshcPg1mZmMY7M30H1F6w30rFA@mail.gmail.com>
References: <cover.1526173613.git.rgb@redhat.com> <baa29a694e352bd4fe8acd0f46f7baca1ad2c147.1526173613.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>,
        Linux Security Module list
        <linux-security-module@vger.kernel.org>,
        Integrity Measurement Architecture
        <linux-integrity@vger.kernel.org>,
        SElinux list <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <baa29a694e352bd4fe8acd0f46f7baca1ad2c147.1526173613.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, May 12, 2018 at 9:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Recognizing that the audit context is an internal audit value, use an
> access function to retrieve the audit context pointer for the task
> rather than reaching directly into the task struct to get it.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h                | 14 ++++++--
>  include/net/xfrm.h                   |  2 +-
>  kernel/audit.c                       |  6 ++--
>  kernel/audit_watch.c                 |  2 +-
>  kernel/auditsc.c                     | 64 +++++++++++++++++-------------------
>  net/bridge/netfilter/ebtables.c      |  2 +-
>  net/core/dev.c                       |  2 +-
>  net/netfilter/x_tables.c             |  2 +-
>  net/netlabel/netlabel_user.c         |  2 +-
>  security/integrity/ima/ima_api.c     |  2 +-
>  security/integrity/integrity_audit.c |  2 +-
>  security/lsm_audit.c                 |  2 +-
>  security/selinux/hooks.c             |  4 +--
>  security/selinux/selinuxfs.c         |  6 ++--
>  security/selinux/ss/services.c       | 12 +++----
>  15 files changed, 64 insertions(+), 60 deletions(-)

Merged, but there was some fuzz due to the missing 1/5 patch and a
handfull of checkpatch.pl fixes.  Please take a look at the commit in
the audit/next branch and if anything looks awry please send a patch
to fix it.

-- 
paul moore
www.paul-moore.com
