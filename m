From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 2/2] tests: test include directories
Date: Tue, 6 Jun 2017 17:58:33 +0200
Message-ID: <20170606155833.GB12447@salvia>
References: <20170606115010.26437-1-ismo.puustinen@intel.com>
 <20170606115010.26437-2-ismo.puustinen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ismo Puustinen <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdFFP6h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 11:58:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D92A1F4B77
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:58:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30AB9FF6FE
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:58:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36D3BFF2D8
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:58:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170606115010.26437-2-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 02:50:10PM +0300, Ismo Puustinen wrote:
> Add tests for:
>   * including an empty directory
>   * including directory with one or two files in it
>   * testing for required trailing slash in directory name
>   * testing for detecting non-existent directory
>   * testing for a broken file in included directory

Also applied, thanks.
