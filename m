From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH next] iptables: on revision mismatch, do not call print/save
Date: Wed, 26 Apr 2017 19:44:04 -0400
Message-ID: <CAF=yD-JSEfRFQWfKf+S_SzOkhYYhMgPYTzBmHO7J5iU47nFHrg@mail.gmail.com>
References: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com>
 <alpine.DEB.2.11.1704212202250.30178@blackhole.kfki.hu> <CAF=yD-+agqtwhkc+pQV+68K0pZiFZX13GcQZVR_Tv7SM_zkmZQ@mail.gmail.com>
 <CAF=yD-LkPtRVuUVmeOCJYaqmRCAKkPDkuxVV4QT_YsDOCfKpyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Willem de Bruijn <willemb@google.com>, anubis@iwwd.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36419 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033013AbdDZXop (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Apr 2017 19:44:45 -0400
Received: by mail-oi0-f66.google.com with SMTP id a3so3881490oii.3
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2017 16:44:45 -0700 (PDT)
In-Reply-To: <CAF=yD-LkPtRVuUVmeOCJYaqmRCAKkPDkuxVV4QT_YsDOCfKpyg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 26, 2017 at 5:15 PM, Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>>> The patch breaks backward/forward compatibility in a match/target.
>>>
>>> When the list of the revisions of a given match/target of iptables is not
>>> exactly the same as for the kernel counter part (when the kernel module
>>> supports less revisions than iptables), then in spite of the supported
>>> match/target, " [unsupported revision]" is printed instead of the
>>> arguments. See https://bugzilla.netfilter.org/show_bug.cgi?id=1147.
>>
>> Thanks for the report.
>>
>>> Please consider reverting the patch. Or we should not stop in
>>> xtables_find_match/xtables_find_target at revision checking when the
>>> revision does not match, until all possibilities is not exhausted.
>>
>> This seems like the better solution to me. The patch fixes a real issue
>> where garbage is printed by misinterpreting struct fields. Iptables should
>> try to lookup the matching revision for a match or target, instead of
>> returning the first one. I'll take a look.
>
> I have a draft patch, but am so far unable to reproduce the problem.
>
> It may be more subtle than what you describe. xtables_find_match
> can call xtables_fully_register_pending_match which calls
> compatible_match_revision to decide whether a match revision
> is supported and, if multiple revisions are supported, which to prefer.

The case reported in bugzilla is for match 'set', which has not had a
new revision since v4 in 2014. Building the exact versions of iptables
and ipset reported there and disabling v4 support in the kernel correctly
reverts to using v3.
