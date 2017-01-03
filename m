From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] scanner: fix search_in_include_path test
Date: Tue, 3 Jan 2017 12:59:00 +0100
Message-ID: <20170103115900.GA24372@salvia>
References: <20170102153002.6711-1-anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756583AbdACL7U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2017 06:59:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8D26B8AD5
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 12:59:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 802469D68F
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 12:59:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F51D9D68F
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 12:59:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170102153002.6711-1-anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 02, 2017 at 04:30:01PM +0100, Anatole Denis wrote:
> clang emits a warning in this function as we're using a boolean as the third
> argument to strncmp. Indeed, this function only checks the first byte of the
> path as is, so files beginning with . will be incorrectly included from the
> current working directory instead of the include directory.

Applied, thanks Anatole.
