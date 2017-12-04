From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] iptables: patch to correct linker flag sequence
Date: Mon, 4 Dec 2017 11:18:39 +0100
Message-ID: <20171204101839.GA13724@salvia>
References: <1511935854-13005-1-git-send-email-jay.shah1@rockwellcollins.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Yogesh Prasad <yogesh.prasad@rockwellcollins.com>,
        Matt Weber <matthew.weber@rockwellcollins.com>
To: Jay Shah <jay.shah1@rockwellcollins.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753087AbdLDKSo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Dec 2017 05:18:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C904820990B
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:18:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B62C6DA873
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:18:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1511935854-13005-1-git-send-email-jay.shah1@rockwellcollins.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 29, 2017 at 12:10:54AM -0600, Jay Shah wrote:
> From: Yogesh Prasad <yogesh.prasad@rockwellcollins.com>
> 
> Description
> This patch will correct the sequence of -pie and -shared options.
>  When used together, -pie should be provided to the linker before
>  -shared. If -pie is provided after -shared, the linker throws an
>  error shown below as example.
> 
> -------------------------------------------------------------------------
> /host/lib/gcc/powerpc-buildroot-linux-gnu/6.4.0/../../../..
> /powerpc-buildroot-linux-gnu/bin/ld: BFD (GNU Binutils) 2.28.1
>  assertion fail elf32-ppc.c:8923
> collect2: error: ld returned 1 exit status
>         + ./libxt_SYNPROXY.man
> make[4]: *** [libxt_TCPOPTSTRIP.so] Error 1
>         + ./libip6t_mh.man
> /host/powerpc-buildroot-linux-gnu/sysroot/usr/lib/Scrt1.o:(.data+0x4):
>  undefined reference to `main'
> /host/lib/gcc/powerpc-buildroot-linux-gnu      + ./libxt_TCPMSS.man
> /6.4.0/../../../../powerpc-buildroot-linux-gnu/bin/ld:
>  BFD (GNU Binutils) 2.28.1 assertion fail elf32-ppc.c:8923
> collect2: error: ld returned 1 exit status
> -------------------------------------------------------------------------

Applied.

Out of curiosity: Does it say anywhere that the options need to be in
a specific order, eg. documentation.
