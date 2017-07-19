From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: netlink: Remove variable nf_mon_sock.
Date: Wed, 19 Jul 2017 19:11:32 +0200
Message-ID: <20170719171132.GB18262@salvia>
References: <596f51c4.c744620a.84997.9346@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753382AbdGSRLl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 13:11:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14F79523DD
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:11:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF8D9DA46D
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:11:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9C7BDA80A
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:11:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <596f51c4.c744620a.84997.9346@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 06:04:07PM +0530, Varsha Rao wrote:
> Remove variable nf_mon_sock of type structure mnl_socket to avoid
> duplicity. Instead variable nf_sock of the same type is passed as
> argument to netlink_monitor(). Also remove netlink_open_mon_sock()
> function definition, which is no longer required.

Applied, thanks Varsha.
