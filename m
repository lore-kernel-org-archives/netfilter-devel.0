Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469E5C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Mar 2023 00:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCCAJ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 19:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCAJ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 19:09:29 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6803636687
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 16:09:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXszG-0005EU-Np; Fri, 03 Mar 2023 01:09:26 +0100
Date:   Fri, 3 Mar 2023 01:09:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Major =?iso-8859-15?Q?D=E1vid?= <major.david@balasys.hu>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: CPU soft lockup in a spin lock using tproxy and nfqueue
Message-ID: <20230303000926.GC9239@breakpoint.cc>
References: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
 <20230302142946.GB309@breakpoint.cc>
 <f8d03b81-8980-b54e-a2a3-57f8e54044be@balasys.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8d03b81-8980-b54e-a2a3-57f8e54044be@balasys.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Major Dávid <major.david@balasys.hu> wrote:
> Thanks,
> 
> I builded and tested in my Jammy environment, and I could not reproduce
> any soft lockups with this patch anymore.

Thanks.

> But I am also wondering that the inet_twsk_deschedule_put is really
> needed in this particular case in tproxy? As I understand it, there
> is an other independent mechanism which destroys tw sockets, so no
> need do it here?

Which one?  As far as I can see TCP stack would end up adding a
duplicate quadruple to the hash if we only drop the reference and
keep the listen sk around.

And if we assign the tw socket to the skb TCP stack might not be able
to find the correct listener if the service is on a different port
than what is in the TCP header.

Did I miss anything?
