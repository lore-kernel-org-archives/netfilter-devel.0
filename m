Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601F0C05028
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjITU5n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjITU5l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E953D8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dH4sr/fwzfmMEuc7KCxrpAhWso4nd81EQkSMctigek4=; b=Sa6kCLobG94kkI3WGk2R76bDKe
        kpFk8En2Nxg0j5r0SFby54Tov4P73B6kfGzSzZY4KSyzEgFLzfOkUxX9sy3dzWd5YNogH/RnJWs+O
        u2hQPDPaznZrYdB+Y+QM5+6zKpSqIHv/h34dp37wVksHvVaXIaAYLcylcBwaLPpHvb/w9IIcbGmuz
        2GWiH/bVYF65w/BU3ekS+KoVE8gzDREaAeFACAgECOquXPI6lNSzsD4ZzhWpnDm7oq+eEprkk30f2
        Ca9X3Ua6FHqFUPrXz0kW5YC1nGhQ+Sz8l9nXvQWLFbaFc5zLTpAs4x7R28QgGCzhUhKLCHg6Jk0X4
        RtlrOBOw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GL-0007qZ-GW; Wed, 20 Sep 2023 22:57:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/9] Misc JSON parser fixes
Date:   Wed, 20 Sep 2023 22:57:18 +0200
Message-ID: <20230920205727.22103-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a series of memory corruption fixes kindly reported by Secunet.
The first six patches fix severe issues, patches seven and eight
moderate problems and the last one a minor issue noticed along the way.

Phil Sutter (9):
  parser_json: Catch wrong "reset" payload
  parser_json: Fix typo in json_parse_cmd_add_object()
  parser_json: Proper ct expectation attribute parsing
  parser_json: Fix flowtable prio value parsing
  parser_json: Fix limit object burst value parsing
  parser_json: Fix synproxy object mss/wscale parsing
  parser_json: Wrong check in json_parse_ct_timeout_policy()
  parser_json: Catch nonsense ops in match statement
  parser_json: Default meter size to zero

 src/parser_json.c | 50 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 18 deletions(-)

-- 
2.41.0

