From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/2] Review code regarding output_fp
Date: Thu, 16 Nov 2017 14:34:58 +0100
Message-ID: <20171116133458.GD2455@salvia>
References: <20171116080629.30564-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39520 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbdKPNfG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:35:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE58F2E7855
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:35:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C05E4DA873
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:35:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171116080629.30564-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 16, 2017 at 09:06:27AM +0100, Phil Sutter wrote:
> Grepping the code for 'stdout' revealed two places where
> application-defined output_fp is ignored and instead direct printing to
> stdout happens: One is 'nft export' output, the other is 'nft monitor'
> output if JSON output was chosen. This series fixes both.

Series applied, thanks.
