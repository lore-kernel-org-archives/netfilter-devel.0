From: Oliver Ford <ojford@gmail.com>
Subject: Re: [PATCH v2 1/1] iptables: Fix crash on malformed iptables-restore
Date: Thu, 18 May 2017 16:21:01 +0100
Message-ID: <CAGMVOdvxHUBh6SsvM=V=HeH6quTnKExUvuZVevjB6yMuMxrb8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:34790 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932767AbdERPVC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 11:21:02 -0400
Received: by mail-vk0-f45.google.com with SMTP id y190so26368307vkc.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 08:21:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 18, 2017 at 3:42 PM, Florian Westphal <fw@strlen.de> wrote:
> Oliver Ford <ojford@gmail.com> wrote:
>> --- a/iptables/ip6tables-restore.c
>> +++ b/iptables/ip6tables-restore.c
>> @@ -165,14 +165,33 @@ static void add_param_to_argv(char *parsestart)
>>                       param_buffer[param_len] = '\0';
>>
>>                       /* check if table name specified */
>> -                     if (!strncmp(param_buffer, "-t", 2)
>> -                            || !strncmp(param_buffer, "--table", 8)) {
>> +                     if (param_buffer[0] == '-' && param_buffer[1] != '-'
>> +                             && strchr(param_buffer, 't')) {
>>                               xtables_error(PARAMETER_PROBLEM,
>> -                             "The -t option (seen in line %u) cannot be "
>> -                             "used in ip6tables-restore.\n", line);
>> +                                     "The -t option (seen in line %u) cannot be "
>> +                                     "used in ip6tables-restore.\n", line);
>> +                             exit(1);
>> +                     } else if (!strncmp(param_buffer, "--", 2)
>> +                             && strchr(param_buffer, 't')) {
>
> Why this strchr() ?
>
> if (!strncmp(param_buffer, "--t", 3) &&
>     !strncmp(param_buffer, "--table", strlen(param_buffer))
>        err();
>
> should work.
>

"strncmp(param_buffer, "--t", 3)" wouldn't return 0 if you had an
invalid parameter like "--ftabl".

>> +                             /* If we begin with a '--' and have a 't', check
>> +                              * that the parameter is in the list of valid options */
>> +                             const char* t_options[] = {
>
> If this is needed, I'd suggest
>
> static const char * const t_options[] = {
>
>> +                                     "delete", "insert", "list", "list-rules", "delete-chain",
>> +                                     "destination", "dst", "protocol", "in-interface", "match",
>> +                                     "out-interface", "wait", "wait-interval", "exact",
>> +                                     "fragments", "set-counters", "goto"};
>> +                             int i, opt_len = ARRAY_SIZE(t_options);
>> +                             for (i = 0; i < opt_len; i++) {
>> +                                     if (!strcmp(param_buffer + 2, t_options[i])) {
>> +                                             goto t_passed;
>> +                                     }
>> +                             }
>
> If this t_options[] thing is really needed i'd try to stick this into
> a helper function so we don't have to duplicate this in all 3
> incarnations.
>
> Thanks for working on this.

Can do, but the code already duplicates everything else across all 3
incarnations so I thought it best to stick with the established
pattern :-) If you'd prefer it extracted I'll send a new version.
