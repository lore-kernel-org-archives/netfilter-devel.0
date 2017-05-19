From: Oliver Ford <ojford@gmail.com>
Subject: Re: [PATCH v3 1/1] iptables: Fix crash on malformed iptables-restore
Date: Fri, 19 May 2017 12:24:57 +0100
Message-ID: <CAGMVOduXqbvS=V0Y+pNmXrV2GSTCe2Nv4fWSBcuys81efwQ++w@mail.gmail.com>
References: <1495187664-7807-1-git-send-email-ojford@gmail.com>
 <20170519100410.GB28091@breakpoint.cc> <CAGMVOdu7K-e2t9eU03er+GguG3WYHFwcxR68H+S+Ra6PQok+Yg@mail.gmail.com>
 <20170519103825.GC28091@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:33254 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdESLY7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 07:24:59 -0400
Received: by mail-ua0-f170.google.com with SMTP id e28so24018977uah.0
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 04:24:58 -0700 (PDT)
In-Reply-To: <20170519103825.GC28091@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 11:38 AM, Florian Westphal <fw@strlen.de> wrote:
> Oliver Ford <ojford@gmail.com> wrote:
>> On Fri, May 19, 2017 at 11:04 AM, Florian Westphal <fw@strlen.de> wrote:
>> > Oliver Ford <ojford@gmail.com> wrote:
>> >> Filter a beginning '--t'. Because the getopt_long function allows abbreviations,
>> >> any parameter beginning with '--t' will be treated as '--table'.
>> >
>> > No, thats not correct:
>> > --t is treated as --table.
>> > --tfoo is an invalid option.
>> > --ttl is ttl.
>> >
>> > So this:
>> >
>> >> +                             || !strncmp(param_buffer, "--t", 3)) {
>> >>                               xtables_error(PARAMETER_PROBLEM,
>> >> +                                     "The -t option (seen in line %u) cannot be "
>> >> +                                     "used in ip6tables-restore.\n", line);
>> >
>> > .. rejects rules like
>> >
>> > -A INPUT -m ttl --ttl 32
>>
>> Would strncmp(param_buffer, "--ta", 4) work? I don't think there are
>> any options that begin with --ta other than --table.
>
> That won't catch '--t'.
>
> It will also add trouble later if any module adds an option like --tap,
> --tail, --target, etc.
>
> Whats wrong with:
>
> if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
>      strchr(param_buffer, 't') ||
>      (!strncmp(param_buffer, "--t", 3) &&
>       !strncmp(param_buffer, "--table", strlen(param_buffer)))) {
>
> ?

I've just sent v4 that definitely works now. If you've got
"!strncmp(param_buffer, "--table", strlen(param_buffer))" you don't
also need "!strncmp(param_buffer, "--t", 3)" as --t will get filtered.

I've tested --t --ta --tab --tabl --table gets filtered but not --ttl,
--target, --type.

Also -ftf still gets filtered. Thanks for bearing with this.
