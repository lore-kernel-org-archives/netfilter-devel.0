Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4618C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Mar 2022 19:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiCRTj4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Mar 2022 15:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbiCRTj4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Mar 2022 15:39:56 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C312110CF36
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2022 12:38:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 863B66740102;
        Fri, 18 Mar 2022 20:38:29 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 18 Mar 2022 20:38:27 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-211-146.kabelnet.hu [94.248.211.146])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 3053267400F9;
        Fri, 18 Mar 2022 20:38:27 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id C7D8A3C16F7; Fri, 18 Mar 2022 20:38:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id C5D5D3C16E5;
        Fri, 18 Mar 2022 20:38:26 +0100 (CET)
Date:   Fri, 18 Mar 2022 20:38:26 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Ian Pilcher <arequipeno@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: "Decoding" ipset error codes
In-Reply-To: <86f13f61-ffae-1130-12fa-f638da3558a2@gmail.com>
Message-ID: <3a3d581-f029-2539-ecbf-1798f07a9ea2@netfilter.org>
References: <86f13f61-ffae-1130-12fa-f638da3558a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: maybeham 6%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Ian,

On Wed, 16 Mar 2022, Ian Pilcher wrote:

> I am using libmnl to add entries to an IP set.  (Code here[1] if anyone
> is interested.)  I've got everything working, but I haven't yet found a
> way to "decode" any protocol-specific errors that may be returned,
> because the set is not of the correct type, for example.
> 
> I see that libipset has an ipset_errcode() function but it looks to be
> designed for use only when libipset is being used for the actual netlink
> communication.  (I didn't do that in this case, because libipset looks
> to be targeted only on parsing and executing commands that are passed to
> the ipset command.  It didn't make any sense to me to create a command
> string in a buffer just so libipset could parse it back into information
> that is already known.)

You can avoid parsing: it is possible to fill out the session data fields 
directly by calling ipset_data_set() and then issuing the required 
command.
 
> Is there any way that I can give users of my program something more
> helpful than "unknown error XXXX"?

You can "copy" the errcode table from the libipset source tree. Or it 
could be extended with a new ipset_errcode_raw() command which would just 
translate the returned errcode into the appropriate error string.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
