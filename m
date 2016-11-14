From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Update ip_route_me_harder to consider L3
 domain
Date: Tue, 15 Nov 2016 00:49:42 +0100
Message-ID: <20161114234942.GA9640@salvia>
References: <1478715880-18952-1-git-send-email-dsa@cumulusnetworks.com>
 <20161114225920.GA9221@salvia>
 <6698ac14-9706-88b3-ed1f-0ec47c64fb48@cumulusnetworks.com>
 <20161114234817.GA9609@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org
To: David Ahern <dsa@cumulusnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40538 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934108AbcKNXtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 18:49:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4CE620990A
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 00:49:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C67D1DA808
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 00:49:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA31BDA80B
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 00:49:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161114234817.GA9609@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 12:48:17AM +0100, Pablo Neira Ayuso wrote:
> Hi David,
> 
> On Mon, Nov 14, 2016 at 04:04:26PM -0700, David Ahern wrote:
> > On 11/14/16 3:59 PM, Pablo Neira Ayuso wrote:
> > > Does ip6_route_me_harder need an update too?
> > 
> > I have not hit a use case yet. Rather than blindly going through and
> > adding l3mdev hooks I would like to tie the changes to known uses
> > cases.
> 
> Hm, your follow up patch updates nf_send_reset6() but not
> nf_send_reset(). Sorry but it strikes me as inconsistent that some
> spots are updated and some others are not.

What usecases you have in mind, btw? I can help testing other
scenarios and fix other spots too if it makes sense to do it in one
go.
