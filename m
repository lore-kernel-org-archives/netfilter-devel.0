From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 conntrack-tools] conntrackd: cthelper: ssdp: Track
 UPnP eventing
Date: Sun, 12 Feb 2017 15:05:32 +0100
Message-ID: <20170212140532.GA5528@salvia>
References: <20170105214220.35549-1-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ashley.hughes@blueyonder.co.uk, mnissler@google.com,
        netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49242 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751206AbdBLOFi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 09:05:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE9D596EC7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 15:05:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF61FDA795
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 15:05:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92210DA804
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 15:05:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170105214220.35549-1-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 05, 2017 at 01:42:20PM -0800, Kevin Cernekee wrote:
> The UPnP Device Architecture spec provides a way for devices to connect
> back to control points, called "Eventing" (chapter 4).  This sequence can
> look something like:
> 
> 1) Outbound multicast M-SEARCH packet (dst: 1900/udp)
>  - Create expectation for unicast reply from <any host> to source port
> 
> 2) Inbound unicast reply (there may be several of these from different devices)
>  - Find the device's URL, e.g.
>    LOCATION: http://192.168.1.123:1400/xml/device_description.xml
>  - Create expectation to track connections to this host:port (tcp)
> 
> 3) Outbound connection to device's web server (there will be several of these)
>  - Watch for a SUBSCRIBE request
>  - Find the control point's callback URL, e.g.
>    CALLBACK: <http://192.168.1.124:3500/notify>
>  - Create expectation to open up inbound connections to this host:port
> 
> 4) Inbound connections to control point's web server
>  - The device will send NOTIFY HTTP requests to inform the control point
>    of new events.  These can continue indefinitely.  Each NOTIFY
>    request arrives on a new TCP connection and may have a different
>    source port.
> 
> Add the necessary code to create expectations for each of these
> connections and rewrite the IP in the CALLBACK URL.  Tested with and
> without NAT.

I'm going to place this in the tree. Just follow up with fixes if
required.

Thanks Kevin.
