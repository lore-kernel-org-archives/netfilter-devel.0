From: Oliver Ford <ojford@gmail.com>
Subject: Re: [PATCH v3 1/1] iptables: Fix crash on malformed iptables-restore
Date: Fri, 19 May 2017 11:12:39 +0100
Message-ID: <CAGMVOdu7K-e2t9eU03er+GguG3WYHFwcxR68H+S+Ra6PQok+Yg@mail.gmail.com>
References: <1495187664-7807-1-git-send-email-ojford@gmail.com> <20170519100410.GB28091@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:34228 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdESKMk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 06:12:40 -0400
Received: by mail-ua0-f178.google.com with SMTP id u10so23127889uaf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 03:12:40 -0700 (PDT)
In-Reply-To: <20170519100410.GB28091@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 11:04 AM, Florian Westphal <fw@strlen.de> wrote:
> Oliver Ford <ojford@gmail.com> wrote:
>> Filter a beginning '--t'. Because the getopt_long function allows abbreviations,
>> any parameter beginning with '--t' will be treated as '--table'.
>
> No, thats not correct:
> --t is treated as --table.
> --tfoo is an invalid option.
> --ttl is ttl.
>
> So this:
>
>> +                             || !strncmp(param_buffer, "--t", 3)) {
>>                               xtables_error(PARAMETER_PROBLEM,
>> +                                     "The -t option (seen in line %u) cannot be "
>> +                                     "used in ip6tables-restore.\n", line);
>
> .. rejects rules like
>
> -A INPUT -m ttl --ttl 32

Would strncmp(param_buffer, "--ta", 4) work? I don't think there are
any options that begin with --ta other than --table.
