Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E31C433E5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2413720737
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:18:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpvTVSQ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgGQISh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 04:18:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35382 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbgGQISh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 04:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594973916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3iQemxM0vfs0ZJ7JexzBhkKu5sQVlb+hUv2k6hkxROw=;
        b=HpvTVSQ72NKYREHOTcH16PQ7JZtAoZOzIS8t3HEWNoDwQudb8g/HZhuAJP4GHC1RxL866c
        awKgLzwVfFc69KqJDtpPmPfO4M4tGC/4AZAXPTR9116km5xxpKaGetnFqShPYKpcfBCRmP
        +oEXN4m94G3IuUFbLyay1BmE6pAF/VQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-agvqh-mdMMCOquCPu6Ygaw-1; Fri, 17 Jul 2020 04:18:34 -0400
X-MC-Unique: agvqh-mdMMCOquCPu6Ygaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07FA18015F4;
        Fri, 17 Jul 2020 08:18:33 +0000 (UTC)
Received: from localhost (ovpn-112-32.ams2.redhat.com [10.36.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F01972E4A;
        Fri, 17 Jul 2020 08:18:32 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH v2] iptables: accept lock file name at runtime
References: <20200715065152.4172896-1-gscrivan@redhat.com>
        <20200716215535.GD23632@orbyte.nwl.cc>
Date:   Fri, 17 Jul 2020 10:18:30 +0200
In-Reply-To: <20200716215535.GD23632@orbyte.nwl.cc> (Phil Sutter's message of
        "Thu, 16 Jul 2020 23:55:35 +0200")
Message-ID: <874kq6o8q1.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

thanks for the review.

Phil Sutter <phil@nwl.cc> writes:

> Hi,
>
> On Wed, Jul 15, 2020 at 08:51:52AM +0200, Giuseppe Scrivano wrote:
>> allow users to override at runtime the lock file to use through the
>> XTABLES_LOCKFILE environment variable.
>> 
>> It allows using iptables from a network namespace owned by an user
>> that has no write access to XT_LOCK_NAME (by default under /run), and
>> without setting up a new mount namespace.
>
> This sentence appears overly complicated to me. Isn't the problem just
> that XT_LOCK_NAME may not be writeable? That "user that has no write
> access" is typically root anyway as iptables doesn't support being
> called by non-privileged UIDs.

I'll rephrase it but it is really about the user not having access to the
lock file.

Without involving user namespaces, a simple reproducer for the issue can be:

$ caps="cap_net_admin,cap_net_raw,cap_setpcap,cap_setuid,cap_setgid"
$ capsh --caps="$caps"+eip  --keep=1 --gid=1000 --uid=1000  \
        --addamb="$caps" \
        -- -c "iptables -F ..."

iptables seems to work fine even if the user is not running as root, as
long as enough capabilities are granted.


>> $ XTABLES_LOCKFILE=/tmp/xtables unshare -rn iptables ...
>> 
>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>> ---
>>  iptables/xshared.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> Could you please update the man page as well? Unless you clarify why
> this should be a hidden feature, of course. :)

sure, I'll send a v3 shortly.

Giuseppe

