From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: EPOLLERR on memory mapped netlink socket
Date: Tue, 24 Jan 2017 20:28:58 +0100
Message-ID: <20170124192858.GA10240@salvia>
References: <CA+VDgmP9MigJxiN5snFmLdHw7cydr4JbnBDDPwzex0Tszqgaag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: prashantkumar dhotre <prashantkumardhotre@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdAXT3O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 14:29:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E6AEE1EC2C7
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 20:29:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBEB0DA725
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 20:29:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4177CDA878
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 20:29:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CA+VDgmP9MigJxiN5snFmLdHw7cydr4JbnBDDPwzex0Tszqgaag@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 23, 2017 at 09:20:23AM +0530, prashantkumar dhotre wrote:
[...]
> What could be cause of this and what EPOLLERR on memory mapped netlink
> socket mean.

Note that memory mapped netlink support got removed ~1 year ago:

https://patchwork.ozlabs.org/patch/584709/
