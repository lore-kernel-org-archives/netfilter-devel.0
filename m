Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E5AC28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 12:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7402F206DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 12:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgEFMAQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 08:00:16 -0400
Received: from correo.us.es ([193.147.175.20]:58804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgEFMAQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 08:00:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F2B1D2DA10
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 14:00:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FDF553899
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 14:00:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 152BE4EA8F; Wed,  6 May 2020 14:00:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C06C64EA8F;
        Wed,  6 May 2020 14:00:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 May 2020 14:00:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A253242EE38E;
        Wed,  6 May 2020 14:00:12 +0200 (CEST)
Date:   Wed, 6 May 2020 14:00:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Etienne Champetier <champetier.etienne@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: iptables 1.8.5 ETA ?
Message-ID: <20200506120012.GA21153@salvia>
References: <CAOdf3gqGQQCFJ8O8KVM7fVBYcKLy=UCf+AOvEdaoArMAx98ezg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOdf3gqGQQCFJ8O8KVM7fVBYcKLy=UCf+AOvEdaoArMAx98ezg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 06, 2020 at 07:44:12AM -0400, Etienne Champetier wrote:
> Hi All,
> 
> Pablo told me 3 weeks ago that "It might take a few weeks to make the
> new release."
> (https://bugzilla.netfilter.org/show_bug.cgi?id=1422#c13)
> 
> I'm sure it'll be release when it's ready :) but do you see an
> iptables release happening this month ? (to know if I should just wait
> or go ask maintainers for backports)

Cc'ing Phil. He's got some pending work to push it out.
