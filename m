Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE842C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 11:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCOL7b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 07:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjCOL71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 07:59:27 -0400
X-Greylist: delayed 391 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Mar 2023 04:59:23 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D24667031
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 04:59:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 6B9BA67400EF;
        Wed, 15 Mar 2023 12:52:47 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 15 Mar 2023 12:52:45 +0100 (CET)
Received: from mentat.rmki.kfki.hu (host-94-248-211-167.kabelnet.hu [94.248.211.167])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id D187B67400EB;
        Wed, 15 Mar 2023 12:52:44 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
        id 7569A884; Wed, 15 Mar 2023 12:52:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mentat.rmki.kfki.hu (Postfix) with ESMTP id 71B36900;
        Wed, 15 Mar 2023 12:52:44 +0100 (CET)
Date:   Wed, 15 Mar 2023 12:52:44 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ipset PATCH] tests: hash:ip,port.t: Replace VRRP by GRE
 protocol
In-Reply-To: <ZAuap2hATJLQexpN@orbyte.nwl.cc>
Message-ID: <f0245962-5ea1-5b68-b8d6-258779585a@netfilter.org>
References: <20230310174903.5089-1-phil@nwl.cc> <ZAuap2hATJLQexpN@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil, Pablo,

On Fri, 10 Mar 2023, Phil Sutter wrote:

> On Fri, Mar 10, 2023 at 06:49:03PM +0100, Phil Sutter wrote:
> > Some systems may not have "vrrp" as alias to "carp" yet, so use a
> > protocol which is less likely to cause problems for testing purposes.
> > 
> > Fixes: a67aa712ed912 ("tests: hash:ip,port.t: 'vrrp' is printed as 'carp'")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Patch applied.

Thank you for helping me out in these times! For the time being I can only 
work on ipset sporadically.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
