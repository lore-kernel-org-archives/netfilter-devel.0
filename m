From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] ebtables: Possible problems found by static analysis
 of code
Date: Thu, 23 Jun 2011 20:51:53 +0200
Message-ID: <4E038B49.2080107@pandora.be>
References: <4DF738AE.3060306@redhat.com> <4DF917F5.9000605@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:34965 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab1FWSv4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:51:56 -0400
In-Reply-To: <4DF917F5.9000605@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15-06-11 22:37, Bart De Schuymer wrote:
> Op 14/06/2011 12:32, Jiri Popelka schreef:
>> Hello,
>>
>> we had analyzed the ebtables-v2.0.9-2 code with Coverity.
>> Coverity is commercial enterprise level tool for
>> static analysis (analysis based only on compiling of sources,
>> not based on running of binary) of the code.
>>
>> As a result I have the following patches that should fix some 
>> possible problems.
>> There's a respective part(s) of the Coverity error log in each patch.
>>
>
> Thanks,
>
> I'll have a closer look at them later this week.
>
> cheers,
> Bart
>

I've taken all reported issues into account. The changes are in the 
latest CVS. See below for my comments on your submitted patches:

1. forward_null:

diff 1: no issue, next can only be NULL in the first iteration (unless 
there is a bug). Added an assertion just in case.
diff 2: possible issue. If repl->counters is NULL, then repl->nentries 
is 0 too, though. Depends
on the implementation of fread. Committed an altered patch (note that 
the submitted patch wrongly uses repr instead of repl)

2. no_effect:
removed the negative value checks instead of checking on ULONG_MAX as 
the submitted patch did.

3. overrun_static:
first error: non-issue: part of the API between ebtables userspace and 
kernel
second error: non-issue: part of the API between ebtables userspace and 
kernel: only the initialized elements are needed by the kernel

4. resource_leak:
applied

5. uninit:
applied

6. use_after_free:
added a different fix (the submitted patch made things worse): cc->type 
should be set to CNT_DEL when the original cc->type != CNT_ADD

Thanks again for your time and interest,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

