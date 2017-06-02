From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 3/6 RFC] netfilter: audit only on xtables and ebtables
 syscall rule or standalone
Date: Fri, 2 Jun 2017 11:25:17 -0400
Message-ID: <CAHC9VhQ15-aW_=oK8MiJSuHAWQs8oqDcPn5k3rb0H1TS7UBKFA@mail.gmail.com>
References: <cover.1495124188.git.rgb@redhat.com> <ac9a2120311288328a81d3e07a68857ebd32a21b.1495124188.git.rgb@redhat.com>
 <20170524173606.GB7439@salvia> <20170524180952.GL6203@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>, linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35402 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBPZY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2017 11:25:24 -0400
Received: by mail-lf0-f66.google.com with SMTP id v20so2046656lfa.2
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Jun 2017 08:25:23 -0700 (PDT)
In-Reply-To: <20170524180952.GL6203@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 2:09 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-05-24 19:36, Pablo Neira Ayuso wrote:
>> On Thu, May 18, 2017 at 01:21:49PM -0400, Richard Guy Briggs wrote:
>> > There were syscall events unsolicited by any audit rule caused by a missing
>> > !audit_dummy_context() check before creating an
>> > iptables/ip6tables/arptables/ebtables NETFILTER_CFG record.  Check
>> > !audit_dummy_context() before creating the NETFILTER_CFG record.
>> >
>> > The vast majority of observed unaccompanied records are caused by the fedora
>> > default rule: "-a never,task" and the occasional early startup one is I believe
>> > caused by the iptables filter table module hard linked into the kernel rather
>> > than a loadable module. The !audit_dummy_context() check above should avoid
>> > them.  Audit only when there is an existing syscall audit rule, otherwise issue
>> > a standalone record only on table modification rather than empty table
>> > creation.
>> >
>> > Add subject attributes to the new standalone NETFILTER_CFGSOLO record using
>> > a newly exported audit_log_task().
>>
>> This new NETFILTER_CFGSOLO looks like audit infra is missing some way
>> to export a revision / context to userspace? It's duplicating quite a
>> bit of the code from what I can see in this patch.
>
> Interesting you brought that up.  I did another revision that stores
> this information in a struct audit_context and greatly simplifies the
> code in netfilter and re-uses code in audit itself, which may be a
> better way to go, but that idea needed to settle a bit more before
> seeing peer review.
>
> I'm also having doubts about two record types.

Richard and I had a discussion about this a week (or two?) ago and I'm
currently of the opinion that two record types are a mistake.  I agree
that we need to add the audit_dummy_context() check but the other
changes in this patch I'm less excited about.

-- 
paul moore
www.paul-moore.com
