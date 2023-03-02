Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFE1C678D4
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 19:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCBTke (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 14:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCBTkd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 14:40:33 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC23C58496;
        Thu,  2 Mar 2023 11:40:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXomb-0003N5-2e; Thu, 02 Mar 2023 20:40:05 +0100
Date:   Thu, 2 Mar 2023 20:40:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Bug report DNAT destination not work
Message-ID: <20230302194005.GA9239@breakpoint.cc>
References: <CALidq=VJF36a6DWf8=PNahwHLJd5FKspXVJfmzK3NFCxb6zKbg@mail.gmail.com>
 <20230302104337.GA23204@breakpoint.cc>
 <ABA514EB-3C64-4A16-8D07-1318FB9AB63F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ABA514EB-3C64-4A16-8D07-1318FB9AB63F@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> Hi Florian
> 
> 
> i recheck and libxt_DNAT.so is symlink to libxt_NAT.so
> 
> and i try : 
> 
> iptables v1.8.9 (nf_tables)

What did you try?

>   --modprobe=<command>		try to insert modules using this command
>   --set-counters -c PKTS BYTES	set the counter during insert/append
> [!] --version	-V		print package version.
> 
> 
> and show help .

No idea what you did or what you are trying to show.
IFF you ran "iptables -j DNAT --help", then libxt_DNAT is not
found resp. iptables is looking at the wrong place.

$ iptables-legacy -V
iptables v1.8.9 (legacy)
$ iptables -j DNAT --help
[..]
DNAT target options:
 --to-destination [<ipaddr>[-<ipaddr>]][:port[-port[/port]]]
                  Address to map destination to.
[--random] [--persistent]
$

I can only guess what the problem might be.

Maybe 'strace -f -e file iptables -j DNAT --help' will give a clue,
there should be lines like this:

newfstatat(AT_FDCWD, "/usr/lib64/xtables/libipt_DNAT.so", 0x7ffe94e3f180, 0) = -1 ENOENT
newfstatat(AT_FDCWD, "/usr/lib64/xtables/libxt_DNAT.so", {st_mode=S ... = 0
openat(AT_FDCWD, "/usr/lib64/xtables/libxt_DNAT.so", O_RDONLY|O_CLOEXEC) = 4
