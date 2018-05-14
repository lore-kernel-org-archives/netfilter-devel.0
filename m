From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak81 RFC V2 4/5] audit: use inline function to set audit context
Date: Mon, 14 May 2018 17:51:31 -0400
Message-ID: <CAHC9VhT+9xV-EdChmB4b7pFtNWz2BrEsqWEzqfNSdKg8yj08Jg@mail.gmail.com>
References: <cover.1526173613.git.rgb@redhat.com> <567735cef55507a38120e30bea178980bb146313.1526173613.git.rgb@redhat.com>
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
In-Reply-To: <567735cef55507a38120e30bea178980bb146313.1526173613.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, May 12, 2018 at 9:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Recognizing that the audit context is an internal audit value, use an
> access function to set the audit context pointer for the task
> rather than reaching directly into the task struct to set it.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h | 6 ++++++
>  kernel/auditsc.c      | 7 +++----
>  kernel/fork.c         | 2 +-
>  3 files changed, 10 insertions(+), 5 deletions(-)

Merged with some minor fuzz.

-- 
paul moore
www.paul-moore.com
