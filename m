Return-Path: <SRS0=IEee=3V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CD2C33CB3
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 20:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5652063A
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 20:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580590662;
	bh=YzrxOAgyAnw5zciHuZGlp4qdwfR8oAZMGYk5eT8mUQA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Oy/7tDBTAucaNylkU9O37kLR9y+ZiqHhBKrAqPxA6h/HYIx6UOw2lVflzFYchms5s
	 lKmuFq/xm/5kDcFhmQWg9XxVmG6SlBZDnrPkwE5qGVZKXQVeel05XQ5o6KtiBPpyHl
	 dOgWoRpqHoXwW9JMUl9RhmR4zdCClZptVO7RoJu4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgBAU5i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 15:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgBAU5h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 15:57:37 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1255C2063A;
        Sat,  1 Feb 2020 20:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580590657;
        bh=YzrxOAgyAnw5zciHuZGlp4qdwfR8oAZMGYk5eT8mUQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l4EP7P2kgDX1DWaezdJUCChvEvScThz/BPMuNxiM0CFxaW+BZLsUjG1y3Gkxirqeu
         h8cYa/YM/tTZpeZ1MXO0LcxTk4Qh++q5AwDCyB9qvOOWqJG0vrXYiCYCIB0l7i6C6C
         43uJj3tICjzgCNXZrxMsUKUrlfNMBofjOOZzg91M=
Date:   Sat, 1 Feb 2020 12:57:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] netfilter: ipset: fix suspicious RCU usage in
 find_set_and_id
Message-ID: <20200201125736.453a0fec@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131192428.167274-2-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
        <20200131192428.167274-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 31 Jan 2020 20:24:23 +0100, Pablo Neira Ayuso wrote:
> From: Kadlecsik J=C3=B3zsef <kadlec@blackhole.kfki.hu>
>=20
> find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is held.
> However, in the error path there can be a follow-up recvmsg() without
> the mutex held. Use the start() function of struct netlink_dump_control
> instead of dump() to verify and report if the specified set does not
> exist.
>=20
> Thanks to Pablo Neira Ayuso for helping me to understand the subleties
> of the netlink protocol.
>=20
> Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com
> Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This will trigger a missing signed-off-by check:

Commit 5038517119d5 ("netfilter: ipset: fix suspicious RCU usage in find_se=
t_and_id")
	author Signed-off-by missing
	author email:    kadlec@blackhole.kfki.hu
	committer email: pablo@netfilter.org
	Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
	Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Problem is that the name differs by 'o' vs '=C3=B3' (J=C3=B3zsef Kadlecsik).

I wonder if it's worth getting rid of diacritics for the comparison..
