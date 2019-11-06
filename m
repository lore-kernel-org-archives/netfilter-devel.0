Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D83C5DF63
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 18:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E59BE2178F
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 18:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKFSua (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 13:50:30 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34142 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbfKFSua (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 13:50:30 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iSQNq-0005NP-Vf; Wed, 06 Nov 2019 19:50:23 +0100
Date:   Wed, 6 Nov 2019 19:50:22 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Daniel Huhardeaux <tech@tootai.net>
Cc:     Netfilter list <netfilter-devel@vger.kernel.org>
Subject: Re: ipv6 forward rule after prerouting - Howto
Message-ID: <20191106185022.GT15063@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Daniel Huhardeaux <tech@tootai.net>,
        Netfilter list <netfilter-devel@vger.kernel.org>
References: <eb91d7f8-e344-c697-b2e0-ff4fb77245b2@tootai.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb91d7f8-e344-c697-b2e0-ff4fb77245b2@tootai.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Nov 06, 2019 at 06:55:56PM +0100, Daniel Huhardeaux wrote:
> Hello,
> 
> I setup prerouting rules with maps like
> 
> chain prerouting {
>     type nat hook prerouting priority 0; policy accept;
>     iif "ens3" ip6 saddr . tcp dport vmap @blacklist_tcp
>     if "ens3" ip6 saddr . udp dport vmap @blacklist_udp
>     dnat to tcp dport map @fwdtoip_tcp:tcp dport map @fwdtoport_tcp
>     dnat to udp dport map @fwdtoip_udp:udp dport map @fwdtoport_udp
>     ip6 daddr 2a01:729:16e:10::9998 redirect to :tcp dport map @redirect_tcp
>     ip6 daddr 2a01:729:16e:10::9998 redirect to :udp dport map @redirect_udp
>     ct status dnat accept
>     }
> 
> Default behavior in ip6 filter forward table is to drop. This means that 
> my above rules are blocked, I see (u18srv being the machine who will 
> forward the traffic to another one):
> 
> 18:32:00.476524 IP6 <hostname>.41174 > u18srv.12345: Flags [S], seq 
> 126955234, win 28640, options [mss 1432,sackOK,TS val 2255777795 ecr 
> 0,nop,wscale 7], length 0 
>  
> 
> 18:32:08.668468 IP6 <hostname>.41174 > u18srv.12345: Flags [S], seq 
> 126955234, win 28640, options [mss 1432,sackOK,TS val 2255785986 ecr 
> 0,nop,wscale 7], length 0
> 18:32:24.796392 IP6 <hostname>.41174 > u18srv.12345: Flags [S], seq 
> 126955234, win 28640, options [mss 1432,sackOK,TS val 2255802114 ecr 
> 0,nop,wscale 7], length 0
> 
> Now if I change my default value to accept for ip6 filter forward table, 
> all is good.
> 
> Question: how can I add forward rule to filter table using the existing 
> maps which are defined in nat tables ? Other solution ?
> 
> I thought that ct status dnat accept was the key to archieve my goal, 
> seems not :(
> 
> Thanks for any hint

Please be aware that 'accept' verdict will only stop the packet from
traversing the current chain and any later chain may still drop the
packet. Only 'drop' verdict is final in that sense.

So regarding your problem, I guess you have to add the 'ct state' based
accept rule to forward chain to prevent the drop policy to affect the
packet. Your prerouting chain already has an accept policy, so explicit
accepting shouldn't be needed.

Cheers, Phil
