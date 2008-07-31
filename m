From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD2 PATCH 11/11] Add option to CFLAGS to avoid useless warning.
Date: Thu, 31 Jul 2008 12:09:49 +0200
Message-ID: <48918F6D.8040307@trash.net>
References: <20080723162746.GB31572@bayen.regit.org> <1217166686-28508-12-git-send-email-eric@inl.fr> <48918A9D.5040204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39471 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYGaKJx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:09:53 -0400
In-Reply-To: <48918A9D.5040204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
>> This patch adds the "-Wno-unused-parameter" option to CFLAGS. This suppress
>> gcc warning that can not be fixed due to the usage of generic system like
>> callback where function definition has to be standardized.
>>
>> Signed-off-by: Eric Leblond <eric@inl.fr>
>> ---
>>  configure.in |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/configure.in b/configure.in
>> index 96cc2d0..8889575 100644
>> --- a/configure.in
>> +++ b/configure.in
>> @@ -30,7 +30,7 @@ dnl Checks for library functions.
>>  AC_FUNC_VPRINTF
>>  AC_CHECK_FUNCS(socket strerror)
>>  
>> -CFLAGS="$CFLAGS -Wall -Wextra"
>> +CFLAGS="$CFLAGS -Wall -Wextra -Wno-unused-parameter"
> 
> Applied from 1 to 10. Thanks Eric.
> 
> With regards to this patch. This warning vanishes is we remove -Wextra.
> 
> We are not using this flag in any other userspace tools and IIRC Patrick
> said that -Wextra did not provide very useful warning. Any comment on this?


It includes some useful warnings, but also some that tend to
produce lots of false positives. We could enable the useful
ones manually, or simply wait and see how much false positives
we'll actually get.
