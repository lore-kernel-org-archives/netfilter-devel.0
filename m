Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385D7C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 14:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08DE2233A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 14:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfHVOtg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfHVOtg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 10:49:36 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61826300DA2C;
        Thu, 22 Aug 2019 14:49:36 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8BE25DE5C;
        Thu, 22 Aug 2019 14:49:35 +0000 (UTC)
Message-ID: <b258d831a555293816d520eeace318e1e6a159bb.camel@redhat.com>
Subject: Re: nft equivalent of iptables command
From:   Dan Williams <dcbw@redhat.com>
To:     Florian Westphal <fw@strlen.de>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Date:   Thu, 22 Aug 2019 09:49:34 -0500
In-Reply-To: <20190822141645.GH20113@breakpoint.cc>
References: <69AAC254-AF78-4918-82B5-14B3EDB10EDB@cisco.com>
         <20190822141645.GH20113@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 22 Aug 2019 14:49:36 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2019-08-22 at 16:16 +0200, Florian Westphal wrote:
> Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
> > Hello,
> > 
> > I am trying to find an equivalent nft command for the following
> > iptables command.  Specifically "physdev" and "addrtype", I could
> > not find so far, some help would be very appreciated.
> > -m physdev ! --physdev-is-in            
> 
> This has no equivalent.  The rule above matches when 'call-iptables'
> sysctl
> is enabled and the packet did not enter via a bridge interface.
> So, its only false when it did enter via a bridge interface.

Also note that the rule in kube-proxy that adds physdev/physdev-is-in
has the comment:

// This is imperfect in the face of network plugins that might not use
a bridge, but we can revisit that later.

and it clearly doesn't work when the network plugin doesn't use a
bridge interface for containers, which is a lot of them. In fact, that
rule should instead be rewritten upstream to use "-s !<ClusterCIDR>" or
something rather than rules about a network interface that may/may not
exist.

IMHO this is really an issue in kube-proxy (code was added in 2015)
that hasn't been cleaned up since Kubernetes started supporting more
diverse network plugins.

Dan

> In case the sysctl is off, the rule always matches and can be
> omitted.
> 
> nftables currently assumes that call-iptables is off, and that
> bridges have their own filter rules in the netdev and/or
> bridge families.
> 
> inet/ip/ip6 are assumed to only see packets that are routed by the ip
> stack.
> 
> > -m addrtype ! --src-type LOCAL 
> 
> fib saddr type != local

