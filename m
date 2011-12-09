From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH v3] iptables: libxt_recent: Add support for --reap option
Date: Thu, 08 Dec 2011 19:31:42 -0700
Message-ID: <4EE1730E.90200@canonical.com>
References: <1322789373-30474-1-git-send-email-tim.gardner@canonical.com> <alpine.LNX.2.01.1112021628190.5296@frira.zrqbmnf.qr> <4ED91CEF.1080006@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1439 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab1LICbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:31:52 -0500
In-Reply-To: <4ED91CEF.1080006@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/02/2011 11:46 AM, Tim Gardner wrote:
> On 12/02/2011 08:30 AM, Jan Engelhardt wrote:
>>
>> On Friday 2011-12-02 02:29, Tim Gardner wrote:
>>> @@ -34,6 +36,8 @@ static const struct xt_option_entry recent_opts[] = {
>>> .excl = F_ANY_OP, .flags = XTOPT_INVERT},
>>> {.name = "seconds", .id = O_SECONDS, .type = XTTYPE_UINT32,
>>> .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds)},
>>> + {.name = "reap", .id = O_REAP, .type = XTTYPE_NONE,
>>> + .also = F_SECONDS },
>>> {.name = "hitcount", .id = O_HITCOUNT, .type = XTTYPE_UINT32,
>>> .flags = XTOPT_PUT, XTOPT_POINTER(s, hit_count)},
>>> {.name = "rttl", .id = O_RTTL, .type = XTTYPE_NONE,
>>
>>> +
>>> + if ((info->check_set& XT_RECENT_REAP)&& !info->seconds)
>>> + xtables_error(PARAMETER_PROBLEM,
>>> + "recent: you must specify `--seconds' with `--reap'");
>>> }
>>
>> Well, I did mean that .also = F_SECONDS makes the extra
>> "info->check_set& XT_RECENT_REAP)&& !info->seconds" test
>> redundant. Or, the error message is wrong, because you are
>> actually testing for seconds==0 rather than "reap was specified
>> without seconds".
>> Is seconds=0 even useful for non-reap cases?
>
> Its not meaningful in that 0 is the default value in the kernel filter
> and implies no timeout.
>
>> If not, we should probably consider using .min=1 on the --seconds
>> parameter, in which case the test is also redundant.
>>
>
> Done. Tested with the following combinations and received the expected
> failures on the first 2:
>
> iptables -A FORWARD -m recent --rcheck --seconds 0 -j DROP
> iptables -A FORWARD -m recent --rcheck --reap -j DROP
> iptables -A FORWARD -m recent --rcheck --seconds 10 --reap -j DROP
>
> rtg

Jan ? Is this v3 patch sufficient ?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
