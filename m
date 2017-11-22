From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/4] netfilter: add BUILD_BUG_ON asserts for hook
 array sizes
Date: Wed, 22 Nov 2017 13:20:25 +0100
Message-ID: <20171122122025.GA29456@salvia>
References: <20171113164107.11259-1-fw@strlen.de>
 <20171113164107.11259-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44258 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752527AbdKVMU3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 07:20:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 952031B840F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 13:20:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82A7EDA7F1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 13:20:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113164107.11259-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Mon, Nov 13, 2017 at 05:41:05PM +0100, Florian Westphal wrote:
> Check that the array hooks are not accessed out-of-bounds.
> Next patch will then reduce their sizes to reflect the number
> of hooks implemented for each family.

I'm hitting this here.

In file included from ./include/linux/kernel.h:10:0,
                 from ./include/linux/uio.h:12,
                 from ./include/linux/socket.h:8,
                 from net/decnet/dn_route.c:60:
In function ‘nf_hook.constprop’,
    inlined from ‘NF_HOOK.constprop’ at
./include/linux/netfilter.h:279:6:
./include/linux/compiler.h:319:38: error: call to
‘__compiletime_assert_221’ declared with attribute error: BUILD_BUG_ON
failed: hook >= ARRAY_SIZE(net->nf.hooks_decnet)
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
./include/linux/compiler.h:299:4: note: in definition of macro
‘__compiletime_assert’
    prefix ## suffix();    \
    ^
./include/linux/compiler.h:319:2: note: in expansion of macro
‘_compiletime_assert’
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^
./include/linux/build_bug.h:47:37: note: in expansion of macro
‘compiletime_assert’
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^
./include/linux/build_bug.h:71:2: note: in expansion of macro
‘BUILD_BUG_ON_MSG’
  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
  ^
./include/linux/netfilter.h:221:3: note: in expansion of macro
‘BUILD_BUG_ON’
   BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_decnet));
   ^
