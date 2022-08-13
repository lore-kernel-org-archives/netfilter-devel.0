Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13112C00140
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Aug 2022 01:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiHMB1J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Aug 2022 21:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiHMB1G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Aug 2022 21:27:06 -0400
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F0FAB192
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2022 18:27:02 -0700 (PDT)
Date:   Sat, 13 Aug 2022 01:26:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1660354019; x=1660613219;
        bh=kb625J0IUauTJO8d7XhQ3BjkqrKcF1EBIVDd+tdFmp0=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:Feedback-ID:From:To:
         Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=oNKczTNJvaJrmJvcdAhg5h9+zDVZW0YN9xCjs7ffDRwN9nPuE5Eyj/kSX0y5q+Vun
         Y7bqJGlQU6C/U6CZHI7JJyIwyQMlgI28kj3BFasLjZuZc8hfkXtrJajkQ/T4Jkswz9
         Q9GOEUdhcxQxeoVAf3udc+j5JahBLQxOFU8pOwPE=
To:     Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>, stable@kernel.org
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: [PATCH net 1/3] netfilter: nf_conntrack_tcp: re-init for syn packets only
Message-ID: <17c87824-7d04-c34e-bf6a-d8b874242636@tmb.nu>
Feedback-ID: 19711308:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Den 2022-08-12 kl. 22:17, skrev Jakub Kicinski:
> On Fri, 12 Aug 2022 09:34:14 -0400 Neal Cardwell wrote:
>> This first commit is an important bug fix for a serious bug that causes
>> TCP connection hangs for users of TCP fast open and nf_conntrack:
>>
>>    c7aab4f17021b netfilter: nf_conntrack_tcp: re-init for syn packets on=
ly
>>
>> We are continuing to get reports about the bug that this commit fixes.
>>
>> It seems this fix was only backported to v5.17 stable release, and not f=
urther,
>> due to a cherry-pick conflict, because this fix implicitly depends on a
>> slightly earlier v5.17 fix in the same spot:
>>
>>    82b72cb94666 netfilter: conntrack: re-init state for retransmitted sy=
n-ack
>>
>> I manually verified that the fix c7aab4f17021b can be cleanly cherry-pic=
ked
>> into the oldest (v4.9.325) and newest (v5.15.60) longterm release kernel=
s as
>> long as we first cherry-pick that related fix that it implicitly depends=
 on:
>>
>> 82b72cb94666b3dbd7152bb9f441b068af7a921b
>> netfilter: conntrack: re-init state for retransmitted syn-ack
>>
>> c7aab4f17021b636a0ee75bcf28e06fb7c94ab48
>> netfilter: nf_conntrack_tcp: re-init for syn packets only
>>
>> So would it be possible to backport both of those fixes with the followi=
ng
>> cherry-picks, to all LTS stable releases?
>>
>> git cherry-pick 82b72cb94666b3dbd7152bb9f441b068af7a921b
>> git cherry-pick c7aab4f17021b636a0ee75bcf28e06fb7c94ab48
>
> Thanks a lot Neal! FWIW we have recently changed our process and no
> longer handle stable submissions ourselves, so in the future feel free
> to talk directly to stable@ (and add CC: stable@ tags to patches).
>
> I'm adding stable@, let's see if Greg & team can pick things up based
> on your instructions :)
>

besides testing that they apply,
one should also check that the resulting code actually builds...

net/netfilter/nf_conntrack_proto_tcp.c: In function 'tcp_in_window':
net/netfilter/nf_conntrack_proto_tcp.c:560:3: error: implicit
declaration of function 'tcp_init_sender'; did you mean 'tcp_init_cwnd'?
[-Werror=3Dimplicit-function-declaration]



So this one is also needed:
cc4f9d62037ebcb811f4908bba2986c01df1bd50
netfilter: conntrack: move synack init code to helper

for it to actually build on 5.15


--
Thomas

