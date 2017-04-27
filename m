From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH next] iptables: on revision mismatch, do not call
 print/save
Date: Thu, 27 Apr 2017 11:18:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1704271114480.21354@blackhole.kfki.hu>
References: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com> <alpine.DEB.2.11.1704212202250.30178@blackhole.kfki.hu> <CAF=yD-+agqtwhkc+pQV+68K0pZiFZX13GcQZVR_Tv7SM_zkmZQ@mail.gmail.com> <CAF=yD-LkPtRVuUVmeOCJYaqmRCAKkPDkuxVV4QT_YsDOCfKpyg@mail.gmail.com>
 <CAF=yD-JSEfRFQWfKf+S_SzOkhYYhMgPYTzBmHO7J5iU47nFHrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Willem de Bruijn <willemb@google.com>, anubis@iwwd.com
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:58301 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755037AbdD0JSo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Apr 2017 05:18:44 -0400
In-Reply-To: <CAF=yD-JSEfRFQWfKf+S_SzOkhYYhMgPYTzBmHO7J5iU47nFHrg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Willem,

On Wed, 26 Apr 2017, Willem de Bruijn wrote:

> On Wed, Apr 26, 2017 at 5:15 PM, Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >>> The patch breaks backward/forward compatibility in a match/target.
> >>>
> >>> When the list of the revisions of a given match/target of iptables is not
> >>> exactly the same as for the kernel counter part (when the kernel module
> >>> supports less revisions than iptables), then in spite of the supported
> >>> match/target, " [unsupported revision]" is printed instead of the
> >>> arguments. See https://bugzilla.netfilter.org/show_bug.cgi?id=1147.
> >>
> >> Thanks for the report.
> >>
> >>> Please consider reverting the patch. Or we should not stop in
> >>> xtables_find_match/xtables_find_target at revision checking when the
> >>> revision does not match, until all possibilities is not exhausted.
> >>
> >> This seems like the better solution to me. The patch fixes a real issue
> >> where garbage is printed by misinterpreting struct fields. Iptables should
> >> try to lookup the matching revision for a match or target, instead of
> >> returning the first one. I'll take a look.
> >
> > I have a draft patch, but am so far unable to reproduce the problem.
> >
> > It may be more subtle than what you describe. xtables_find_match
> > can call xtables_fully_register_pending_match which calls
> > compatible_match_revision to decide whether a match revision
> > is supported and, if multiple revisions are supported, which to prefer.
> 
> The case reported in bugzilla is for match 'set', which has not had a
> new revision since v4 in 2014. Building the exact versions of iptables
> and ipset reported there and disabling v4 support in the kernel correctly
> reverts to using v3.

Maybe the case can be reproduced with the following steps, but I'm 
guessing:

- rules inserted
- iptables binary downgraded/upgraded
- rules listed

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
