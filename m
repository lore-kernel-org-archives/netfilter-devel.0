Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8A6EB64DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Jun 2023 18:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjFYSfQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Jun 2023 14:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjFYSfQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Jun 2023 14:35:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01190184;
        Sun, 25 Jun 2023 11:35:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qDUZr-0006pz-Ia; Sun, 25 Jun 2023 20:35:11 +0200
Date:   Sun, 25 Jun 2023 20:35:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jason Vas Dias <jason.vas.dias@ptt.ie>,
        Jason Vas Dias <jason.vas.dias@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: Linux netfilter / iptables : How to enable iptables TRACE chain
 handling with nf_log_syslog on RHEL8+?
Message-ID: <20230625183511.GC3207@breakpoint.cc>
References: <hhttuv65e9.fsf@jvdspc.jvds.net>
 <hhr0pz60h5.fsf@jvdspc.jvds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hhr0pz60h5.fsf@jvdspc.jvds.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jason Vas Dias <jason.vas.dias@ptt.ie> wrote:
>   RE: you wrote:
>   > Run "xtables-monitor --trace".
> 
>   Thanks for the info about xtables-monitor - yes, that does give alot
>   of extra information about rule chain processing.
> 
>   But I'd just like to understand :
>     Why does this work under kernel v6.2.16 and not under v4.18.0-477 ?
>     :
>     # iptables -t raw -A PREROUTING -p icmp -j TRACE
>     # iptables -t raw -A OUTPUT -p icmp -j TRACE
>     # modprobe nf_log_ipv4
>     # echo nf_log_ipv4 > /proc/sys/net/netfilter/nf_log/2
> 
>   How can I enable the 'nf_log_syslog' module, so that it does
>   in fact emit TRACE kernel messages to syslog, as it purports
>   to be able to do, under v4.18.0-477 ?

You need to install iptables-legacy, not shipped in RHEL8.
