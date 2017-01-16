From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_cttimeout] Use __EXPORTED rather than
 EXPORT_SYMBOL
Date: Mon, 16 Jan 2017 14:30:34 +0100
Message-ID: <20170116133034.GA31271@salvia>
References: <20170104223026.33362-1-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751536AbdAPNak (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 08:30:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BBFB7392E08
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:30:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC7DF9D69D
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:30:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C6749D694
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:30:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170104223026.33362-1-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 04, 2017 at 02:30:25PM -0800, Kevin Cernekee wrote:
> clang is sensitive to the ordering of
> __attribute__((visibility("default"))) relative to the function
> body.  gcc is not.  So if we try to re-declare an existing function
> with default visibility, clang prints a warning and generates
> a broken .so file in which nfct_timeout_* are not exported to library
> callers.
> 
> Move the attribute up into the function definition to make clang happy.

Applied, thanks.
