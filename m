From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] tests: shell: add maps tests
Date: Tue, 10 Jan 2017 22:11:48 +0100
Message-ID: <20170110211148.GB16808@salvia>
References: <20170106214457.GA4739@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdAJVLx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Jan 2017 16:11:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BAA9C16B286
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2017 22:11:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA4E7A7DAE
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2017 22:11:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9ADE17C70
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2017 22:11:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170106214457.GA4739@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 06, 2017 at 07:44:57PM -0200, Elise Lennion wrote:
> Test adding elements to simple and interval maps.

Minor nitpick: I have included here that is based on previous work
from Richard Mörbitz and myself.

Also applied, thanks!
