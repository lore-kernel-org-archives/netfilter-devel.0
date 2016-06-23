From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipset: Backports for the nla_put_net64() API changes
Date: Thu, 23 Jun 2016 20:04:54 +0200
Message-ID: <20160623180454.GA15678@salvia>
References: <20160623102211.GA31272@hydrogen>
 <20160623103744.GA10764@salvia>
 <CAMQP0smTrOCvq6nXH3u5VLfLdj1nf7_D6760RCmCUx6DfrynNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60905 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbcFWSFE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 14:05:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 128A4E7DA8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 20:05:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F0BD1100A48
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 20:05:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9728C100A51
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 20:04:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAMQP0smTrOCvq6nXH3u5VLfLdj1nf7_D6760RCmCUx6DfrynNA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 23, 2016 at 06:41:45PM +0700, Neutron Soutmun wrote:
> On Thu, Jun 23, 2016 at 5:37 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Jun 23, 2016 at 05:22:11PM +0700, Neutron Soutmun wrote:
> >> * Backports the patch "libnl: nla_put_net64():align on a 64-bit area" [1]
> >>   by Nicolas Dichtel <nicolas.dichtel@6wind.com>
> >>
> >> * Since the nla_put_net64() API has been changed, therefore, the
> >>   ip_set_compat.h.in should provides the macro IPSET_NLA_PUT_NET64 that
> >>   point to the nla_put_net64() with appropriate number of arguments.
> >>
> >>   The build script should distinguish the API changes by detect for
> >>   the existence of nla_put_64bit() function in include/net/netlink.h.
> >>   This function was added in the same patches set and called by
> >>   the nla_put_be64() that called by nla_put_net64() respectively.
> >
> > What are you specifically fixing with this?
> 
> Sorry that the patch is not clear the point.
> This patch is on top of the ipset master branch, http://git.netfilter.org/ipset,
> which I face a problem to build the latest ipset kernel module against
> the linux-4.7~rc4-1~exp1 (Debian Experimental).
> 
> Therefore, I have backported the patch from mainline and prepared the
> macro for backward compatible which
> the ipset kernel module could be compiled with earlier kernel version (< 4.7)

What is exactly the compilation error you get?

Userspace should refer to any of those _PAD attributes, so this should
be fine.
