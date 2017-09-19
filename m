From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/2] store expression instead of data type as set key
Date: Tue, 19 Sep 2017 14:49:52 +0200
Message-ID: <20170919124954.26852-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54692 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751519AbdISMtg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2017 08:49:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a prerequisite to later support dynamic data types, e.g. string,
as a set key.  The string datatype (and integer) do not have a fixed size,
instead the size is determined by the expression.

This keeps the expression all the way down to set construction.
Furthermore, in case of concatenations we can use EXPR_CONCAT to allow the
netlink linearization step to determine the original sizes of the keys
components.

Both changes are preparation work, they add no feature.


