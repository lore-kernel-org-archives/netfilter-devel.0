From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH next] iptables: on revision mismatch, do not call print/save
Date: Fri, 21 Apr 2017 19:45:13 -0400
Message-ID: <CAF=yD-+agqtwhkc+pQV+68K0pZiFZX13GcQZVR_Tv7SM_zkmZQ@mail.gmail.com>
References: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com>
 <alpine.DEB.2.11.1704212202250.30178@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Willem de Bruijn <willemb@google.com>, anubis@iwwd.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35087 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426325AbdDUXpz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2017 19:45:55 -0400
Received: by mail-qk0-f194.google.com with SMTP id k139so14274895qke.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2017 16:45:55 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.11.1704212202250.30178@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 21, 2017 at 4:15 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> Hi,
>
> On Thu, 8 Dec 2016, Willem de Bruijn wrote:
>
>> From: Willem de Bruijn <willemb@google.com>
>>
>> Between revisions, the layout of xtables data may change completely.
>> Do not interpret the data in a revision M with a module of revision N.
>>
>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>> ---
>>  iptables/ip6tables.c | 18 ++++++++++++++----
>>  iptables/iptables.c  | 18 ++++++++++++++----
>>  2 files changed, 28 insertions(+), 8 deletions(-)
>
> The patch breaks backward/forward compatibility in a match/target.
>
> When the list of the revisions of a given match/target of iptables is not
> exactly the same as for the kernel counter part (when the kernel module
> supports less revisions than iptables), then in spite of the supported
> match/target, " [unsupported revision]" is printed instead of the
> arguments. See https://bugzilla.netfilter.org/show_bug.cgi?id=1147.

Thanks for the report.

> Please consider reverting the patch. Or we should not stop in
> xtables_find_match/xtables_find_target at revision checking when the
> revision does not match, until all possibilities is not exhausted.

This seems like the better solution to me. The patch fixes a real issue
where garbage is printed by misinterpreting struct fields. Iptables should
try to lookup the matching revision for a match or target, instead of
returning the first one. I'll take a look.
