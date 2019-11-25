Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C5EC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 13:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DCBE2075C
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 13:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QiS9wLY8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfKYN1X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:27:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbfKYN1X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 08:27:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574688441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8GoPFL6+trgYPu3fxHsF7QQGO2IS2jQCosJc/78LhNA=;
        b=QiS9wLY8Lufp4RA/JMBsxk64KOTCTl109sF7qGjv77yhNOnpiC7BN1wQ/bokCo8eCBCV0i
        +Xk77IO1hT/rWcRwo0mjN8NwNLPVhLKad2sKmaqILP6E3OaDSDyQu88qvdizeChcuOll0j
        lgGpCMa0DcYx/3qhJIi1ri4Pb2NkKwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-ZsdzbinkNJ6_ul3Rya_t5Q-1; Mon, 25 Nov 2019 08:27:20 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 093468005AC;
        Mon, 25 Nov 2019 13:27:19 +0000 (UTC)
Received: from elisabeth (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 55C931001901;
        Mon, 25 Nov 2019 13:27:16 +0000 (UTC)
Date:   Mon, 25 Nov 2019 14:26:16 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 1/8] netfilter: nf_tables: Support for
 subkeys, set with multiple ranged fields
Message-ID: <20191125142616.46951155@elisabeth>
In-Reply-To: <20191125095817.bateimhhcxmmhlzj@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
        <90493a6feae0ae64db378fbfc8e9f351d4b7b05d.1574428269.git.sbrivio@redhat.com>
        <20191123200108.j75hl4sm4zur33jt@salvia>
        <20191125103035.7da18406@elisabeth>
        <20191125095817.bateimhhcxmmhlzj@salvia>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ZsdzbinkNJ6_ul3Rya_t5Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 25 Nov 2019 10:58:17 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Mon, Nov 25, 2019 at 10:30:35AM +0100, Stefano Brivio wrote:
> [...]
> > Another idea could be that we get rid of this flag altogether: if we
> > move "subkeys" to set->desc, the ->estimate() functions of rbtree and
> > pipapo can check for those and refuse or allow set selection
> > accordingly. I have no idea yet if this introduces further complexity
> > for nft, because there we would need to decide how to create start/end
> > elements depending on the existing set description instead of using a
> > single flag. I can give it a try if it makes sense.  
> 
> nft_set_desc can probably store a boolean 'concat' that is set on if
> the NFTA_SET_DESC_SUBKEY attribute is specified. Then, this flag is
> not needed and you can just rely on ->estimate() as you describe.

I could even just check desc->num_subkeys from your patch then, without
adding another field to nft_set_desc. Too ugly?

> The hashtable will just ignore this description, it does not need the
> description even if userspace pass it on since the interval flag is
> set on.
> 
> You just have to update the rbtree to check for desc->concat, if this
> is true, then rbtree->estimate() returns false.

Yes, I think it all makes sense, thanks for detailing the idea. I'll get
to this in a few hours.

> BTW, then probably you can rename this attribute to
> NFT_SET_DESC_CONCAT?

It would include sizes, though. What about NFT_SET_DESC_SUBSIZE or
NFT_SET_DESC_FIELD_SIZE?

-- 
Stefano

