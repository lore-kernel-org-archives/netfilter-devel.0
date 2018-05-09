From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak81 RFC V1 0/5] audit: group task params
Date: Wed, 9 May 2018 11:53:57 -0400
Message-ID: <CAHC9VhRY-hhBb+Kg19Cfy87MSHseUO40j9PC8wsdmHQmcV0zDQ@mail.gmail.com>
References: <cover.1525466167.git.rgb@redhat.com>
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
In-Reply-To: <cover.1525466167.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, May 4, 2018 at 4:54 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Group the audit parameters for each task into one structure.
> In particular, remove the loginuid and sessionid values and the audit
> context pointer from the task structure, replacing them with an audit
> task information structure to contain them.  Use access functions to
> access audit values.
>
> Note:  Use static allocation of the audit task information structure
> initially.  Dynamic allocation was considered and attempted, but isn't
> ready yet.  Static allocation has the limitation that future audit task
> information structure changes would cause a visible change to the rest
> of the kernel, whereas dynamic allocation would mostly hide any future
> changes.
>
> The first four access normalization patches could stand alone.

I agree that the first four patches have some standalone value, and
since we are currently at -rc4, did you want to post another patchset
of just those four patches with feedback incorporated?  I imagine that
should be quick work, and that way they aren't help up with any
problems/discussion regarding the take_struct changes.

> Passes audit-testsuite.
>
> Richard Guy Briggs (5):
>   audit: normalize loginuid read access
>   audit: convert sessionid unset to a macro
>   audit: use inline function to get audit context
>   audit: use inline function to set audit context
>   audit: collect audit task parameters
>
>  MAINTAINERS                          |  2 +-
>  include/linux/audit.h                | 30 ++++++++++---
>  include/linux/audit_task.h           | 31 ++++++++++++++
>  include/linux/sched.h                |  6 +--
>  include/net/xfrm.h                   |  4 +-
>  include/uapi/linux/audit.h           |  1 +
>  init/init_task.c                     |  8 +++-
>  kernel/audit.c                       |  4 +-
>  kernel/audit_watch.c                 |  2 +-
>  kernel/auditsc.c                     | 82 ++++++++++++++++++------------------
>  kernel/fork.c                        |  2 +-
>  net/bridge/netfilter/ebtables.c      |  2 +-
>  net/core/dev.c                       |  2 +-
>  net/netfilter/x_tables.c             |  2 +-
>  net/netlabel/netlabel_user.c         |  2 +-
>  security/integrity/ima/ima_api.c     |  2 +-
>  security/integrity/integrity_audit.c |  2 +-
>  security/lsm_audit.c                 |  2 +-
>  security/selinux/hooks.c             |  4 +-
>  security/selinux/selinuxfs.c         |  6 +--
>  security/selinux/ss/services.c       | 12 +++---
>  21 files changed, 129 insertions(+), 79 deletions(-)
>  create mode 100644 include/linux/audit_task.h
>
> --
> 1.8.3.1
>



-- 
paul moore
www.paul-moore.com
