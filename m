From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: warn users about queue
 allocation errors
Date: Tue, 25 Apr 2017 14:40:45 +0200
Message-ID: <CAOkSjBh8rV0U1FjWYsOetKBzGyzMH4dx44ir+h6CikZdrWS5Eg@mail.gmail.com>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270928606.1751.8172963085482513292.stgit@nfdev2.cica.es> <20170425113401.GA5355@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34739 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1430486AbdDYMlH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 08:41:07 -0400
Received: by mail-oi0-f68.google.com with SMTP id y11so33445672oie.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 05:41:07 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id s193sm9419575oie.21.2017.04.25.05.41.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Apr 2017 05:41:05 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id y11so137315572oie.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 05:41:05 -0700 (PDT)
In-Reply-To: <20170425113401.GA5355@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 April 2017 at 13:34, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 20, 2017 at 07:28:06PM +0200, Arturo Borrero Gonzalez wrote:
>> These warnings, if they happen, should help users.
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
>> ---
>>  src/channel.c  |    6 +++++-
>>  src/queue_tx.c |   11 +++++++++--
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/src/channel.c b/src/channel.c
>> index acbfa7d..b2f114d 100644
>> --- a/src/channel.c
>> +++ b/src/channel.c
>> @@ -19,6 +19,7 @@
>>  #include "channel.h"
>>  #include "network.h"
>>  #include "queue.h"
>> +#include "log.h"
>>
>>  static struct channel_ops *ops[CHANNEL_MAX];
>>  extern struct channel_ops channel_mcast;
>> @@ -161,8 +162,11 @@ static void channel_enqueue_errors(struct channel *c)
>>       struct channel_error *error;
>>
>>       qobj = queue_object_new(Q_ELEM_ERR, sizeof(struct channel_error));
>> -     if (qobj == NULL)
>> +     if (qobj == NULL) {
>> +             dlog(LOG_WARNING, "could not enqueue channel errors, failed to"
>> +                  " allocate memory");
>
> Did you ever hit this?
>

I don't know, no way to know in a production system since this happen silently.

Since conntrackd can be of critical importance in some environments I
guess it doesn't harm
to be more verbose. This concrete memory allocation failure isn't
interesting per se, but it could be related
to other more serious issues on the system.
