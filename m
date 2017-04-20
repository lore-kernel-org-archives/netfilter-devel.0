From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: extensions: don't add nat by default
Date: Thu, 20 Apr 2017 10:11:32 +0200
Message-ID: <20170420081135.20812-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46784 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S943482AbdDTILR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 04:11:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nat extension only holds information needed by pptp and the masquerade target (and
in the latter case its not essential), so no need to attach it by default.

First two patches add the nat extension in masquerade and pptp case, 3rd patch
gets rid of the default-add.

This saves 8 bytes in the extension blob unless a connection
is subject to MASQERUADE and/or pptp nat helper.

