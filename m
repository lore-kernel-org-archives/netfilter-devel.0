From: Kevin Cernekee <cernekee@chromium.org>
Subject: Snooping expected connections in a user CT helper
Date: Tue, 16 Aug 2016 21:51:00 -0700
Message-ID: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org, ashley.hughes@blueyonder.co.uk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33144 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcHQEvZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 00:51:25 -0400
Received: by mail-io0-f177.google.com with SMTP id 38so126849934iol.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 21:51:23 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com. [209.85.223.170])
        by smtp.gmail.com with ESMTPSA id s185sm11052905ita.21.2016.08.16.21.51.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Aug 2016 21:51:21 -0700 (PDT)
Received: by mail-io0-f170.google.com with SMTP id 38so126849670iol.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 21:51:21 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am trying to extend the ssdp user helper in conntrackd to handle
event subscriptions on a UPnP control point.  The flow looks like
this:

1) Outbound multicast M-SEARCH packet (dst: 1900/udp)
 - Create expectation for unicast reply from <any host> to source port

2) Inbound unicast reply (there may be several of these from different devices)
 - Find the device's URL, e.g.
   LOCATION: http://192.168.1.123:1400/xml/device_description.xml
 - Create expectation to track connections to this host:port (tcp)

3) Outbound connection to device's web server (there will be several of these)
 - Watch for a SUBSCRIBE request
 - Find the control point's callback URL, e.g.
   CALLBACK: <http://192.168.1.124:3500/notify>
 - Create expectation to open up inbound connections to this host:port

4) Inbound connection to control point's web server
 - Once this is complete, the subscription should work

So, all of the port numbers except 1900 are dynamic, and thus each
stage depends on the result of the previous stage.  Therefore I need
the callback to inspect the traffic for stages (1)-(3).

Currently, ssdp_helper_cb() only gets called for stage (1).  Is there
something I can do when creating the expectation to tell netfilter
that I would like to receive callbacks when the unicast reply from (2)
is received?

Alternatively, is there an iptables rule that I should be creating for
this purpose?  I tried this:

    iptables -t raw -I INPUT -m helper --helper ssdp -j CT --helper ssdp

but `-m helper` did not work in the raw table, and `-j CT` did not
work in the filter table.  `-m state --state RELATED` also did not
work in the raw table.
