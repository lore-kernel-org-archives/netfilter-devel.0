From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [PATCH] Add support for negated lookup operator
Date: Thu, 17 Jul 2014 23:17:27 +0800
Message-ID: <1405610250-6631-1-git-send-email-yshuiv7@gmail.com>
Cc: pablo@netfilter.org, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37325 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGQPRr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:17:47 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so3022111pab.14
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2014 08:17:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following patches add support for negated lookup operator, and use it to
fix bug #888

kernel:
  nftables: Add a flags attribute for lookup operator
libnftnl:
  lookup: Add support for the flag attribute
nftables:
  expr: Interpret OP_NEQ against a set as OP_LOOKUP
