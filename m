Return-Path: <SRS0=AczV=AE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1E0C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 02:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C4F20720
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 02:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgFWChk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:37:40 -0400
Received: from ciao.gmane.io ([159.69.161.202]:42538 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730456AbgFWChk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 22:37:40 -0400
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gnnd-netfilter-devel@m.gmane-mx.org>)
        id 1jnYoc-0007iN-Lb
        for netfilter-devel@vger.kernel.org; Tue, 23 Jun 2020 04:37:38 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     netfilter-devel@vger.kernel.org
From:   trentbuck@gmail.com (Trent W. Buck)
Subject: Re: [MAINTENANCE] Shutting down FTP services at netfilter.org
Followup-To: gmane.comp.security.firewalls.netfilter.general
Date:   Tue, 23 Jun 2020 12:37:21 +1000
Message-ID: <87o8pabj8e.fsf@goll.lan>
References: <20200603113712.GA24918@salvia> <20200603171621.GC717800@nataraja>
        <nycvar.YFH.7.77.849.2006032004220.24581@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Cc:     netfilter@vger.kernel.org
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> writes:

> On Wednesday 2020-06-03 19:16, Harald Welte wrote:
>>On Wed, Jun 03, 2020 at 01:37:12PM +0200, Pablo Neira Ayuso wrote:
>>> So netfilter.org will also be shutting down FTP services
>>
>> with HTTP there is no real convenient way to get directory listings
>> in a standardized / parseable format.
>
> There was convention, but no standard.

IIUC RFC 4918 (WebDAV) can, in principle, do this.
But it's awful so nobody does. :-)

I agree that rsync:// is the easy and obvious replacement for anon FTP
(when HTTP isn't sufficient).

