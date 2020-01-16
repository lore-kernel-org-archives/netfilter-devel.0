Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2674C33CAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 21:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D11420748
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 21:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fTK2Lb9n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbgAPVaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 16:30:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28669 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388435AbgAPVaB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 16:30:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579210200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUGNJL2/Wf026kdMIts/pJT5YKTZt1aptj+7LyeYLmk=;
        b=fTK2Lb9nIWmkyged+E4vyCEMIUc4tO1xzyqthUG1F2nupgE4VTig3ZMbq4A3u7uiZtv+kv
        0edXcSJ1xsPc0Hi6dIyQuNKmfs913MFCOwgf6HmR0HrfZ7g/CR67gEB3mjShKizlPRxe9l
        392yUfIz9jbL4/vHFldhJwQ5uXCc58M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-4BE-gvcyMeSokQ9liZEf5A-1; Thu, 16 Jan 2020 16:29:58 -0500
X-MC-Unique: 4BE-gvcyMeSokQ9liZEf5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A02D803A20;
        Thu, 16 Jan 2020 21:29:56 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-12.phx2.redhat.com [10.3.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B0681001901;
        Thu, 16 Jan 2020 21:29:48 +0000 (UTC)
Date:   Thu, 16 Jan 2020 16:29:46 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 1/9] netfilter: normalize x_table function
 declarations
Message-ID: <20200116212946.mwnk45v2px4e42uj@madcap2.tricolour.ca>
References: <cover.1577830902.git.rgb@redhat.com>
 <194bdc565d548a14e12357a7c1a594605b7fdf0f.1577830902.git.rgb@redhat.com>
 <f8ee5829-f094-96b8-40c2-b0278f93fb03@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <f8ee5829-f094-96b8-40c2-b0278f93fb03@6wind.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-01-08 17:47, Nicolas Dichtel wrote:
> Le 06/01/2020 =E0 19:54, Richard Guy Briggs a =E9crit=A0:
> > Git context diffs were being produced with unhelpful declaration type=
s
> > in the place of function names to help identify the funciton in which
> > changes were made.
> Just for my information, how do you reproduce that? With a 'git diff'?

git format-patch is how it is presenting as a problem, which I assume
would also be git diff.

> > Normalize x_table function declarations so that git context diff
> > function labels work as expected.
> >=20
> [snip]
> >=20
> > --=20
> > 1.8.3.1
> git v1.8.3.1 is seven years old:
> https://github.com/git/git/releases/tag/v1.8.3.1
>=20
> I don't see any problems with git v2.24. Not sure that the patch brings=
 any
> helpful value except complicating backports.

It brings value to anyone who is on a distro that is stable and only
slightly behind.  There are other features of git 2.x that I'd like to
start using (git worktrees) but I'll have to wait until I can afford to
upgrade.

> Nicolas

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

