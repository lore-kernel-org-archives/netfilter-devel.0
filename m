From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] conntrack-tools: Fix build for old automake.
Date: Thu, 7 Apr 2016 19:33:43 +0200
Message-ID: <570699F7.1010907@chello.at>
References: <1459762780-10255-1-git-send-email-mart.frauenlob@chello.at>
 <1459762780-10255-2-git-send-email-mart.frauenlob@chello.at>
 <20160407164758.GA5353@salvia>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:33185 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756057AbcDGRdo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:33:44 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoDoM-0008Uh-5P
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 19:33:42 +0200
In-Reply-To: <20160407164758.GA5353@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.04.2016 18:47, Pablo Neira Ayuso wrote:
> On Mon, Apr 04, 2016 at 11:39:40AM +0200, Mart Frauenlob wrote:
>>   autoreconf fails with automake version smaller than 1.12,
>>   because of undefined macro AM_PROG_AR.
>>   So only expand it if it's actually defined.
>>
>> Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
>> ---
>>   configure.ac |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/configure.ac b/configure.ac
>> index c541034..2c5913f 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -14,7 +14,7 @@ AC_SUBST([libdl_LIBS])
>>
>>   AC_PROG_CC
>>   AC_DISABLE_STATIC
>> -AM_PROG_AR
>> +m4_ifdef([AM_PROG_AR], [AM_PROG_AR]) dnl Workaround for Automake 1.11
>
> How old is your old system? is it still a distro maintained version?

cat /etc/debian_version
6.0.10
Has automake 1.11.

> BTW, you can remove the comment, we can get to this information
> through 'git annotate' these days.
>
> Thanks.
>

