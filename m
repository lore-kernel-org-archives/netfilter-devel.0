Return-Path: <SRS0=26XO=A2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC2EC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jul 2020 06:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C4220672
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jul 2020 06:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iqd5/eyC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgGOGTi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jul 2020 02:19:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728444AbgGOGTi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jul 2020 02:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594793976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6NOtdHWceIhiBs/ucdbaxw/zo5Lrvs30csQL9Tq9S5w=;
        b=iqd5/eyCSErx6a7MLuietNTz5sfypFfdgG3aeVc0Y7s2X1rTm0YgzFSTw3Oz2UUhs47Xqs
        h3VSg31gLijX7qgzNJ5eiQLA1px17GLK/O8Yb8emqLzABjLWLuiVuZv81zvKgxUOcU5sNc
        Dz4rdqaCTjc8RoWoKWv462jvb4t6cCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-PqBO3s58M_mVeE0gJd6mOw-1; Wed, 15 Jul 2020 02:19:34 -0400
X-MC-Unique: PqBO3s58M_mVeE0gJd6mOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 679691080;
        Wed, 15 Jul 2020 06:19:33 +0000 (UTC)
Received: from localhost (ovpn-112-32.ams2.redhat.com [10.36.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D7EF79CF3;
        Wed, 15 Jul 2020 06:19:32 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: accept lock file name at runtime
References: <20200714165206.4078549-1-gscrivan@redhat.com>
        <20200714232709.GC23632@orbyte.nwl.cc>
Date:   Wed, 15 Jul 2020 08:19:31 +0200
In-Reply-To: <20200714232709.GC23632@orbyte.nwl.cc> (Phil Sutter's message of
        "Wed, 15 Jul 2020 01:27:09 +0200")
Message-ID: <87sgdtti4s.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> writes:

> Hi,
>
> On Tue, Jul 14, 2020 at 06:52:06PM +0200, Giuseppe Scrivano wrote:
>> allow users to override at runtime the lock file to use through the
>> XTABLES_LOCKFILE environment variable.
>> 
>> It allows using iptables from a network namespace owned by an user
>> that has no write access to XT_LOCK_NAME (by default under /run), and
>> without setting up a new mount namespace.
>> 
>> $ XTABLES_LOCKFILE=/tmp/xtables unshare -rn iptables ...
>> 
>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>> ---
>>  iptables/xshared.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>> 
>> diff --git a/iptables/xshared.c b/iptables/xshared.c
>> index c1d1371a..291f1c4b 100644
>> --- a/iptables/xshared.c
>> +++ b/iptables/xshared.c
>> @@ -248,13 +248,18 @@ void xs_init_match(struct xtables_match *match)
>>  
>>  static int xtables_lock(int wait, struct timeval *wait_interval)
>>  {
>> +	const *lock_file;
>
> This does not look right. Typo?

yes sorry, I've messed it up.  I'll send a v2.

Thanks,
Giuseppe

