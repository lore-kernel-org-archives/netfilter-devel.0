Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A793CC433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 21:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7586C64E3D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 21:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhBKVEl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 16:04:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBKVEi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 16:04:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613077391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaBoUEFNY4Hfsu8q49h7KfWFimnqp7p8cmVy/yVWHcQ=;
        b=JOO7Dw5eooJTAPyRp0UnoBx6zOxcGxgUT35O+tcUwrooHMmabLNEGUrgDhhP32QgjEzq0K
        c9FJ4x3S36Daq40GpOTevSdNHdzirCVTuU8LOUI/c/xf1s07PTXQwuoKN4X7z5cyNHQtjv
        TpWARsJ08yO/dsj/SvGvOv2u/RglAiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-2_TTrdD2OY25agubiKVEow-1; Thu, 11 Feb 2021 16:03:10 -0500
X-MC-Unique: 2_TTrdD2OY25agubiKVEow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C716E80403B;
        Thu, 11 Feb 2021 21:03:08 +0000 (UTC)
Received: from x2.localnet (ovpn-118-15.rdu2.redhat.com [10.10.118.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B31E60636;
        Thu, 11 Feb 2021 21:02:57 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org, Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change events
Date:   Thu, 11 Feb 2021 16:02:55 -0500
Message-ID: <4087569.ejJDZkT8p0@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com> <20210211151606.GX3158@orbyte.nwl.cc> <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday, February 11, 2021 11:29:34 AM EST Paul Moore wrote:
> > If I'm not mistaken, iptables emits a single audit log per table, ipset
> > doesn't support audit at all. So I wonder how much audit logging is
> > required at all (for certification or whatever reason). How much
> > granularity is desired?
 
  <snip> 

> I believe the netfilter auditing was mostly a nice-to-have bit of
> functionality to help add to the completeness of the audit logs, but I
> could very easily be mistaken.  Richard put together those patches, he
> can probably provide the background/motivation for the effort.

There are certifications which levy requirements on information flow control. 
The firewall can decide if information should flow or be blocked. Information 
flow decisions need to be auditable - which we have with the audit target. 
That then swings in requirements on the configuration of the information flow 
policy.

The requirements state a need to audit any management activity - meaning the 
creation, modification, and/or deletion of a "firewall ruleset". Because it 
talks constantly about a ruleset and then individual rules, I suspect only 1 
summary event is needed to say something happened, who did it, and the 
outcome. This would be in line with how selinux is treated: we have 1 summary 
event for loading/modifying/unloading selinux policy.

Hope this helps...

-Steve


