Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E01EB64DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jul 2023 06:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjGKG1t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jul 2023 02:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjGKG1s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jul 2023 02:27:48 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5254116
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 23:27:46 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 1987458733E81; Tue, 11 Jul 2023 08:27:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 18D9660BF4F0C;
        Tue, 11 Jul 2023 08:27:45 +0200 (CEST)
Date:   Tue, 11 Jul 2023 08:27:45 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] xt_asn: support quiet mode
In-Reply-To: <20230710044718.2682302-1-philipp@redfish-solutions.com>
Message-ID: <695806p-1nos-43ps-7rs8-nrnpor8r6r73@vanv.qr>
References: <20230710044718.2682302-1-philipp@redfish-solutions.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2023-07-10 06:47, Philip Prindeville wrote:
>Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>

Both applied.
