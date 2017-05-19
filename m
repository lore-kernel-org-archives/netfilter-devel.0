From: Oliver Ford <ojford@gmail.com>
Subject: Re: [PATCH v3 1/1] iptables: Fix crash on malformed iptables-restore
Date: Fri, 19 May 2017 13:03:01 +0100
Message-ID: <CAGMVOds=AKndSW7hp8fnRps6NpYjGz-AoppqFBD82ZPJhRRROQ@mail.gmail.com>
References: <1495187664-7807-1-git-send-email-ojford@gmail.com>
 <20170519100410.GB28091@breakpoint.cc> <CAGMVOdu7K-e2t9eU03er+GguG3WYHFwcxR68H+S+Ra6PQok+Yg@mail.gmail.com>
 <20170519103825.GC28091@breakpoint.cc> <CAGMVOduXqbvS=V0Y+pNmXrV2GSTCe2Nv4fWSBcuys81efwQ++w@mail.gmail.com>
 <20170519113613.GD28091@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:35613 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdESMDD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 08:03:03 -0400
Received: by mail-vk0-f49.google.com with SMTP id h16so10618917vkd.2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 05:03:03 -0700 (PDT)
In-Reply-To: <20170519113613.GD28091@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 12:36 PM, Florian Westphal <fw@strlen.de> wrote:
> Oliver Ford <ojford@gmail.com> wrote:
>> On Fri, May 19, 2017 at 11:38 AM, Florian Westphal <fw@strlen.de> wrote:
>> > Oliver Ford <ojford@gmail.com> wrote:
>> >> On Fri, May 19, 2017 at 11:04 AM, Florian Westphal <fw@strlen.de> wrote:
>> >> > Oliver Ford <ojford@gmail.com> wrote:
>> >> >> Filter a beginning '--t'. Because the getopt_long function allows abbreviations,
>> >> >> any parameter beginning with '--t' will be treated as '--table'.
>> >> >
>> >> > No, thats not correct:
>> >> > --t is treated as --table.
>> >> > --tfoo is an invalid option.
>> >> > --ttl is ttl.
>> >> >
>> >> > So this:
>> >> >
>> >> >> +                             || !strncmp(param_buffer, "--t", 3)) {
>> >> >>                               xtables_error(PARAMETER_PROBLEM,
>> >> >> +                                     "The -t option (seen in line %u) cannot be "
>> >> >> +                                     "used in ip6tables-restore.\n", line);
>> >> >
>> >> > .. rejects rules like
>> >> >
>> >> > -A INPUT -m ttl --ttl 32
>> >>
>> >> Would strncmp(param_buffer, "--ta", 4) work? I don't think there are
>> >> any options that begin with --ta other than --table.
>> >
>> > That won't catch '--t'.
>> >
>> > It will also add trouble later if any module adds an option like --tap,
>> > --tail, --target, etc.
>> >
>> > Whats wrong with:
>> >
>> > if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
>> >      strchr(param_buffer, 't') ||
>> >      (!strncmp(param_buffer, "--t", 3) &&
>> >       !strncmp(param_buffer, "--table", strlen(param_buffer)))) {
>> >
>> > ?
>>
>> I've just sent v4 that definitely works now. If you've got
>> "!strncmp(param_buffer, "--table", strlen(param_buffer))" you don't
>> also need "!strncmp(param_buffer, "--t", 3)" as --t will get filtered.
>
> Its needed, else '--' marker gets detected as 'table', e.g.:
> -A INPUT -m ttl --ttl 32 -j ACCEPT --

Ok I've put that back in in v5 and just sent it.
