Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADABC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC86A20843
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfHNHpp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 03:45:45 -0400
Received: from correo.us.es ([193.147.175.20]:42880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbfHNHpp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 03:45:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4940EDB0D
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 09:45:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B56E97E061
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 09:45:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AAE2B50F3F; Wed, 14 Aug 2019 09:45:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0145CDA704;
        Wed, 14 Aug 2019 09:45:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 09:45:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CCC444265A2F;
        Wed, 14 Aug 2019 09:45:39 +0200 (CEST)
Date:   Wed, 14 Aug 2019 09:45:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     kbuild-all@01.org, kbuild test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [nf-next:master 14/17]
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please
 update iptables, this file will be removed soon!"
Message-ID: <20190814074539.ort2lumte4gw3oix@salvia>
References: <201908140638.At0bDWvT%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908140638.At0bDWvT%lkp@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Wed, Aug 14, 2019 at 06:05:49AM +0800, kbuild test robot wrote:
> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/pablo/nf-next.git master
> head:   105333435b4f3b21ffc325f32fae17719310db64
> commit: 2a475c409fe81a76fb26a6b023509d648237bbe6 [14/17] kbuild: remove all netfilter headers from header-test blacklist.
> config: sparc64-allmodconfig (attached as .config)
> compiler: sparc64-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 2a475c409fe81a76fb26a6b023509d648237bbe6
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=sparc64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from <command-line>:0:0:
> >> include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
>     #warning "Please update iptables, this file will be removed soon!"
>      ^~~~~~~

I'd suggest you send me a patch to remove this #warning.

userspace iptables still refer to this header. The intention was to
use xt_LOG.h instead and remove these, but userspace was never
updated.
