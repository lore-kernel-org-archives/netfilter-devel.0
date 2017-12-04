From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] Make libnftables a local static library
Date: Mon, 4 Dec 2017 11:06:04 +0100
Message-ID: <20171204100604.GA1809@salvia>
References: <20171130183008.GP32305@orbyte.nwl.cc>
 <20171130183623.19719-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55404 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752808AbdLDKGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Dec 2017 05:06:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1602F1F4B6F
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:06:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04512DA3A3
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 11:06:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171130183623.19719-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 30, 2017 at 07:36:23PM +0100, Phil Sutter wrote:
> This changes Makefiles so that libnftables is built into a static
> library which is not installed. This allows for incompatible changes
> while still providing a library to link to for testing purposes.

Applied, thanks Phil.
