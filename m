Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E62C32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 09:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 461EE2071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 09:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgA0JdJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jan 2020 04:33:09 -0500
Received: from correo.us.es ([193.147.175.20]:58238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729575AbgA0JdI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 04:33:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 770FD5E4783
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2020 10:33:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A455DA705
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2020 10:33:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5FF08DA702; Mon, 27 Jan 2020 10:33:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6742EDA703;
        Mon, 27 Jan 2020 10:33:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jan 2020 10:33:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4A2EB4251481;
        Mon, 27 Jan 2020 10:33:05 +0100 (CET)
Date:   Mon, 27 Jan 2020 10:33:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200127093304.pqqvrxgyzveemert@salvia>
References: <20200119181203.60884-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119181203.60884-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 19, 2020 at 06:12:03PM +0000, Jeremy Sowden wrote:
> When a unary expression is inserted to implement a byte-order
> conversion, the expression being converted has already been evaluated
> and so expr_evaluate_unary doesn't need to do so.  For most types of
> expression, the double evaluation doesn't matter since evaluation is
> idempotent.  However, in the case of payload expressions which are
> munged during evaluation, it can cause unexpected errors:
> 
>   # nft add table ip t
>   # nft add chain ip t c '{ type filter hook input priority filter; }'
>   # nft add rule ip t c ip dscp set 'ip dscp | 0x10'
>   Error: Value 252 exceeds valid range 0-63
>   add rule ip t c ip dscp set ip dscp | 0x10
>                               ^^^^^^^

I'm still hitting this after applying this patch.

nft add rule ip t c ip dscp set ip dscp or 0x10
Error: Value 252 exceeds valid range 0-63
add rule ip t c ip dscp set ip dscp or 0x10
                            ^^^^^^

Probably problem is somewhere else? I'm not sure why we can assume
here that the argument of the unary expression should not be
evaluated.
