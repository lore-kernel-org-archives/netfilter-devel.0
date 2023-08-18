Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B035C05052
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 09:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358932AbjHRJKZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358952AbjHRJJx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 05:09:53 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1028E
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:09:51 -0700 (PDT)
Received: from [78.30.34.192] (port=47818 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qWvUF-000E3B-Vd; Fri, 18 Aug 2023 11:09:47 +0200
Date:   Fri, 18 Aug 2023 11:09:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     kernel test robot <lkp@intel.com>
Cc:     netfilter-devel@vger.kernel.org, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf] netfilter: nf_tables: GC transaction race with abort
 path
Message-ID: <ZN81Vz8/yIBm201d@calendula>
References: <20230817231352.8412-1-pablo@netfilter.org>
 <202308181545.lZbeE7Lm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202308181545.lZbeE7Lm-lkp@intel.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 18, 2023 at 03:48:48PM +0800, kernel test robot wrote:
> Hi Pablo,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on nf/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-GC-transaction-race-with-abort-path/20230818-071545
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master

Wrong tree, we moved to:

https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
