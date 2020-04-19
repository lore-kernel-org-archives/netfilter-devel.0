Return-Path: <SRS0=o3eG=6D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88C1C38A30
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Apr 2020 16:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59472051A
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Apr 2020 16:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgDSQny (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Apr 2020 12:43:54 -0400
Received: from correo.us.es ([193.147.175.20]:35696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgDSQny (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Apr 2020 12:43:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 85E3CC51A6
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Apr 2020 18:43:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78BF72DC71
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Apr 2020 18:43:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6E33720672; Sun, 19 Apr 2020 18:43:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 825D2DA8E6;
        Sun, 19 Apr 2020 18:43:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 19 Apr 2020 18:43:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5C0CD41E4800;
        Sun, 19 Apr 2020 18:43:48 +0200 (CEST)
Date:   Sun, 19 Apr 2020 18:43:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Matt Turner <mattst88@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] build: Allow building from tarballs without
 yacc/lex
Message-ID: <20200419164348.tjr6u5wfxgsz4cwu@salvia>
References: <20200407202337.63505-1-mattst88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407202337.63505-1-mattst88@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 07, 2020 at 01:23:37PM -0700, Matt Turner wrote:
> The generated files are included in the tarballs already, but
> configure.ac was coded to fail if yacc/lex were not found regardless.

Also applied, thanks.
