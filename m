From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 13:34:38 +0200
Message-ID: <20170510113438.GA29824@salvia>
References: <20170510105510.891-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752648AbdEJLet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 07:34:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DD74DFE36
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 13:34:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F0ADFF2E0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 13:34:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CBBC100785
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 13:34:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170510105510.891-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 10, 2017 at 12:55:10PM +0200, Phil Sutter wrote:
> This adds support for printing the process ID and name for changes which
> 'nft monitor' reports:
>
> | nft -a -p monitor
> | add chain ip t2 bla3 # pid 11616 (nft)
> 
> If '-n' was given in addition to '-p', parsing the process name from
> /proc/<pid>/cmdline is suppressed.

That is not the process ID, that is the netlink portID, that is pretty
much useless if we get a robot process with multiple netlink sockets
(likely given that it may want to lookup from interface index to
interface name).
