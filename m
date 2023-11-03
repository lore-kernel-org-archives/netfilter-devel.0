Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A610CC4167D
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbjKCQao (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjKCQan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21746CA
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699028993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wSu0CtxYXVyl9ihDQTo7CABd+d3NWJtHWLMWnRCO4E0=;
        b=E2BdawBwVA4v1DcCH9SXxaTudXlw9GuzlBzABubonIFmFnsi/3ZnOGiB66mrw3YkXSCq9v
        mgl5lUYA7Y3evdCpassZ7rHJ4Q928hPeTKGDXlO7l3oTu/GaVcGBHxYlcOeqKU8RymdaUa
        oEQFrnDWgwAvZR6OVmxUBHx4c/3RW84=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-IHS7aIXcM7i_-T6SWnoiZw-1; Fri,
 03 Nov 2023 12:29:48 -0400
X-MC-Unique: IHS7aIXcM7i_-T6SWnoiZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CC161C02D5D
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 16:29:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E11EA2166B26;
        Fri,  3 Nov 2023 16:29:47 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 0/2] drop warning messages from stmt_print_json()/expr_print_json()
Date:   Fri,  3 Nov 2023 17:25:12 +0100
Message-ID: <20231103162937.3352069-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The second patch "json: drop warning on stderr for missing json() hook
in stmt_print_json()" is important to add .json-nft tests from

  Subject:    [PATCH nft 0/7] add and check dump files for JSON in tests/shell
  Date:   Tue, 31 Oct 2023 19:53:26 +0100

(while fixing the bug in stmt_print_json()/chain_stmt_ops.json might take longer).

This replaces v1:

  Subject:  [PATCH nft 2/7] json: drop messages "warning: stmt ops chain have no json callback"
  Date: Tue, 31 Oct 2023 19:53:28 +0100

and v2:

  Subject:  [PATCH nft 1/2] json: implement json() hook for "symbol_expr_ops"/"variabl_expr_ops"
  Subject:  [PATCH nft 2/2] json: drop handling missing json() hook for "struct expr_ops"
  Date:   Thu,  2 Nov 2023 12:20:28 +0100

Thomas Haller (2):
  json: drop handling missing json() hook in expr_print_json()
  json: drop warning on stderr for missing json() hook in
    stmt_print_json()

 src/expression.c |  2 ++
 src/json.c       | 38 ++++++++++++++++----------------------
 src/statement.c  |  1 +
 3 files changed, 19 insertions(+), 22 deletions(-)

-- 
2.41.0

