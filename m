Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C023C43216
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 11:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51DE360F56
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 11:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhHCLpS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 07:45:18 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:33783 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235833AbhHCLpB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 07:45:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 457EE3C80100;
        Tue,  3 Aug 2021 13:44:44 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue,  3 Aug 2021 13:44:42 +0200 (CEST)
Received: from ix.szhk.kfki.hu (wdc11.wdc.kfki.hu [148.6.200.11])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp1.kfki.hu (Postfix) with ESMTPSA id 2177A3C800F3;
        Tue,  3 Aug 2021 13:44:42 +0200 (CEST)
Received: by ix.szhk.kfki.hu (Postfix, from userid 1000)
        id 0EEC51805C8; Tue,  3 Aug 2021 13:44:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by ix.szhk.kfki.hu (Postfix) with ESMTP id 0ABC7180558;
        Tue,  3 Aug 2021 13:44:42 +0200 (CEST)
Date:   Tue, 3 Aug 2021 13:44:42 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Akshat Kakkar <akshat.1984@gmail.com>
cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: Nf_nat_h323 module not working with Panasonic VCs
In-Reply-To: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
Message-ID: <855ba5f9-7c2-53be-2c10-bdfd2f5d24d@netfilter.org>
References: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Akshat,

On Sat, 24 Jul 2021, Akshat Kakkar wrote:

> However, when there is a dial out from MCU to VCs (i.e. MCU initiate
> call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
> natting works fine but h245 IP address for tcp in h225:CS is replaced
> correctly only for VC2 and not for VC1. For VC1, it is still its
> actual IP (i.e. 10.1.1.12 and not 172.16.1.120).
> 
> Because of this, video call is successful only with VC2 and not with
> VC1, when initiated from MCU. I tried with another panasonic VC
> hardware, there was no change.
> 
> Further packet dump analysis showed that for VC1, there are 3 h225
> packets (setup, call proceeding and alert) before Connect message but
> for VC2 there are only 2 h225 packets (setup and alert) before connect
> message.

Could you send me the full packet dump of both cases?

When the debugging is enabled, there should be debug lines in the kernel 
log for the VC1 case too. It's really strange that there isn't any.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
