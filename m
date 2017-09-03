From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 0/2] libnftables preparation work
Date: Mon,  4 Sep 2017 00:03:54 +0200
Message-ID: <20170903220356.20178-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:38250 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752960AbdICWEG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 18:04:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

Here is two patches relative to libnftables preparation work.

The first one it changing the way a nft_ctx is created to be able
to skip the netlink init function call and also to have some freedom
later.

The second one is getting the printf out. This is completely changed
from what was proposed before. It is now really simple on user side.

BR,
--
Eric
