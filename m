From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] conntrack-tools: Fix build for old automake.
Date: Fri, 8 Apr 2016 08:40:01 +0200
Message-ID: <57075241.80906@chello.at>
References: <1459762780-10255-1-git-send-email-mart.frauenlob@chello.at>
 <1459762780-10255-2-git-send-email-mart.frauenlob@chello.at>
 <20160407164758.GA5353@salvia> <570699F7.1010907@chello.at>
 <20160407175009.GB7271@salvia> <57069E8E.7050709@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at03-2.mx.upcmail.net ([62.179.121.152]:63206 "EHLO
	vie01a-dmta-at03-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbcDHGkE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 02:40:04 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoQ5K-0005yl-3Y
	for netfilter-devel@vger.kernel.org; Fri, 08 Apr 2016 08:40:02 +0200
In-Reply-To: <57069E8E.7050709@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.04.2016 19:53, Mart Frauenlob wrote:
> On 07.04.2016 19:50, Pablo Neira Ayuso wrote:
>> On Thu, Apr 07, 2016 at 07:33:43PM +0200, Mart Frauenlob wrote:
>>> On 07.04.2016 18:47, Pablo Neira Ayuso wrote:
>>>> On Mon, Apr 04, 2016 at 11:39:40AM +0200, Mart Frauenlob wrote:
>>>>>   autoreconf fails with automake version smaller than 1.12,
>>>>>   because of undefined macro AM_PROG_AR.
>>>>>   So only expand it if it's actually defined.
>>>>>
>>>>> Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
>>>>> ---
>>>>>   configure.ac |    2 +-
>>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/configure.ac b/configure.ac
>>>>> index c541034..2c5913f 100644
>>>>> --- a/configure.ac
>>>>> +++ b/configure.ac
>>>>> @@ -14,7 +14,7 @@ AC_SUBST([libdl_LIBS])
>>>>>
>>>>>   AC_PROG_CC
>>>>>   AC_DISABLE_STATIC
>>>>> -AM_PROG_AR
>>>>> +m4_ifdef([AM_PROG_AR], [AM_PROG_AR]) dnl Workaround for Automake 1.11
>>>>
>>>> How old is your old system? is it still a distro maintained version?
>>>
>>> cat /etc/debian_version
>>> 6.0.10
>>> Has automake 1.11.
>>
>> Is that still maintained?
>>
>
> Quoting https://www.debian.org/News/2016/20160212 :
>
> February 12th, 2016
> The Debian Long Term Support (LTS) Team hereby announces that Debian 6.0
> ("squeeze") support will reach its end-of-life on February 29, 2016,
> five years after its initial release on February 6, 2011.
>
> Hm, no longer since 2 months....

What does that macro actually do in configure?

AM_PROG_AR([act-if-fail])

     You must use this macro when you use the archiver in your project, 
if you want support for unusual archivers such as Microsoft lib. The 
content of the optional argument is executed if the archiver interface 
is not recognized; the default action is to abort configure with an 
error message.

Does this archiver get called at all?

