From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Snooping expected connections in a user CT helper
Date: Thu, 18 Aug 2016 03:12:14 +0200
Message-ID: <20160818011214.GA1463@salvia>
References: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ashley.hughes@blueyonder.co.uk
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbcHRBMV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 21:12:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CB187E9768
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 03:12:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7998100A5D
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 03:12:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 68865100A40
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 03:12:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Kevin,

Let me comment on this to make sure I follow.

On Tue, Aug 16, 2016 at 09:51:00PM -0700, Kevin Cernekee wrote:
> Hi,
> 
> I am trying to extend the ssdp user helper in conntrackd to handle
> event subscriptions on a UPnP control point.  The flow looks like
> this:
> 
> 1) Outbound multicast M-SEARCH packet (dst: 1900/udp)
>  - Create expectation for unicast reply from <any host> to source port

This creates the permanent expectation.

> 2) Inbound unicast reply (there may be several of these from different devices)
>  - Find the device's URL, e.g.
>    LOCATION: http://192.168.1.123:1400/xml/device_description.xml
>  - Create expectation to track connections to this host:port (tcp)

This packet is matching the permanent expectation.

Now you want to attach the ssdp helper to track traffic going to
192.168.1.123:1400.

Looking at ctnetlink, it should be possible to make it via
CTA_EXPECT_HELP_NAME. Thus, by when we find a matching expectation,
the helper is set to this new connection too.

See line 1086 in nf_conntrack_core.c.

> 3) Outbound connection to device's web server (there will be several of these)
>  - Watch for a SUBSCRIBE request
>  - Find the control point's callback URL, e.g.
>    CALLBACK: <http://192.168.1.124:3500/notify>
>  - Create expectation to open up inbound connections to this host:port

This is the packet that goes over 192.168.1.123:1400 and creates an
expectation again, right?

> 4) Inbound connection to control point's web server
>  - Once this is complete, the subscription should work

... and this packet matches the expectation that was created in 3.

> So, all of the port numbers except 1900 are dynamic, and thus each
> stage depends on the result of the previous stage.  Therefore I need
> the callback to inspect the traffic for stages (1)-(3).
> 
> Currently, ssdp_helper_cb() only gets called for stage (1).  Is there
> something I can do when creating the expectation to tell netfilter
> that I would like to receive callbacks when the unicast reply from (2)
> is received?
>
> Alternatively, is there an iptables rule that I should be creating for
> this purpose?  I tried this:
> 
>     iptables -t raw -I INPUT -m helper --helper ssdp -j CT --helper ssdp
> 
> but `-m helper` did not work in the raw table, and `-j CT` did not
> work in the filter table.  `-m state --state RELATED` also did not
> work in the raw table.

You don't need this. It should be possible to set the helper that will
be assigned to the related connection (the one that matches) with the
existing code through the ctnetlink interface.
