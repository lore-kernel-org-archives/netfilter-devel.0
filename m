From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the netfilter-next tree
Date: Mon, 20 Mar 2017 11:12:36 +1100
Message-ID: <20170320111236.77c5a05a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:46213 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752131AbdCTANC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Mar 2017 20:13:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

After merging the netfilter-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

net/netfilter/nfnetlink_acct.c: In function 'nfnl_acct_try_del':
net/netfilter/nfnetlink_acct.c:329:15: warning: unused variable 'refcount' [-Wunused-variable]
  unsigned int refcount;
               ^

Introduced by commit

  b54ab92b84b6 ("netfilter: refcounter conversions")

-- 
Cheers,
Stephen Rothwell
