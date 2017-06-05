From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 2/2] tests: test include directories
Date: Tue, 6 Jun 2017 01:54:30 +0200
Message-ID: <20170605235430.GD2314@salvia>
References: <20170605151233.1689-1-ismo.puustinen@intel.com>
 <20170605151233.1689-2-ismo.puustinen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ismo Puustinen <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdFEXyf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 19:54:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B58AC8D0506
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 01:54:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7585100785
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 01:54:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 709EA100784
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 01:54:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170605151233.1689-2-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 05, 2017 at 06:12:33PM +0300, Ismo Puustinen wrote:
> Add tests for:
>   * including an empty directory
>   * including directory with one or two files in it
>   * testing for required trailing slash in directory name
>   * testing for detecting non-existent directory
>   * testing for a broken file in included directory

This looks good to me. Thanks for adding tests!

Will take this once we sort out comestic issues with 1/2.
