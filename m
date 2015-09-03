From: Brendan Heading <brendanheading@gmail.com>
Subject: Re: [PATCH 1/1] solve musl build problem
Date: Thu, 3 Sep 2015 17:42:03 +0100
Message-ID: <CA+BsyQ79wP-ut+kXxmWZvW3qnTs0MFxj7NdLs7yi-2nK_4iExw@mail.gmail.com>
References: <1441298310-3951-1-git-send-email-brendanheading@gmail.com>
	<20150903164739.GA21105@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35471 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbbICQmE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2015 12:42:04 -0400
Received: by vkaw128 with SMTP id w128so27710556vka.2
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Sep 2015 09:42:03 -0700 (PDT)
In-Reply-To: <20150903164739.GA21105@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry Pablo - wrong mailing list! Please ignore.

regards

Brendan

On 3 September 2015 at 17:47, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Sep 03, 2015 at 05:38:30PM +0100, Brendan Heading wrote:
>> musl does not include <sys/queue.h> which is a series of macros
>> implementing linked lists etc. The suggestion on the part of the musl devs
>> is to include a copy in the source tree. The header here is lifted from
>> glibc but appears to be 3-clause BSD licensed.
>>
>> Signed-off-by: Brendan Heading <brendanheading@gmail.com>
>> ---
>>  src/lookup_kas.c |   2 +-
>>  src/main.c       |   2 +-
>>  src/queue.h      | 574 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 576 insertions(+), 2 deletions(-)
>>  create mode 100644 src/queue.h
>>
>> diff --git a/src/lookup_kas.c b/src/lookup_kas.c
>> index 09fad98..8dfad5f 100644
>> --- a/src/lookup_kas.c
>> +++ b/src/lookup_kas.c
>
> Where is this file in our netfilter tree?
