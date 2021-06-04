Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE61C47083
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 05:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1B2613F8
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 05:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFDFsL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 01:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhFDFsK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 01:48:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2287EC06174A;
        Thu,  3 Jun 2021 22:46:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lp2et-0003BD-HT; Fri, 04 Jun 2021 07:46:15 +0200
Date:   Fri, 4 Jun 2021 07:46:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Florian Westphal <fw@strlen.de>, 0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [netfilter]  a0aa657b74:
 WARNING:at_kernel/locking/lockdep.c:#lockdep_init_map_type
Message-ID: <20210604054615.GA32304@breakpoint.cc>
References: <20210601162136.19444-3-fw@strlen.de>
 <20210604030057.GA2227@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604030057.GA2227@xsang-OptiPlex-9020>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

kernel test robot <oliver.sang@intel.com> wrote:
> [   83.355329] ------------[ cut here ]------------
> [   83.359909] DEBUG_LOCKS_WARN_ON(!name)
> [   83.359913] WARNING: CPU: 0 PID: 4931 at kernel/locking/lockdep.c:4665 lockdep_init_map_type (kbuild/src/consumer/kernel/locking/lockdep.c:4665 (discriminator 9)) 
> [   83.373072] Modules linked in: nfnetlink(+) btrfs blake2b_generic xor zstd_compress raid6_pq libcrc32c sd_mod intel_rapl_msr intel_rapl_common t10_pi sg x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i915 ipmi_devintf ipmi_msghandler mei_wdt wmi_bmof ahci libahci rapl intel_cstate i2c_i801 intel_uncore libata i2c_smbus intel_pch_thermal mei_me mei wmi intel_gtt video intel_pmc_core acpi_pad ip_tables
> [   83.413628] CPU: 0 PID: 4931 Comm: modprobe Not tainted 5.13.0-rc3-00737-ga0aa657b7490 #1
> [   83.421755] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.8.1 12/05/2017

The patch misses an update in nfnetlink subsystem, will send a v2.
