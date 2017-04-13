From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue][PATCH 2/2] Declare the define visivility
 attribute together
Date: Fri, 14 Apr 2017 01:37:19 +0200
Message-ID: <20170413233719.GB8577@salvia>
References: <20170410195804.18238-1-raj.khem@gmail.com>
 <20170410195804.18238-2-raj.khem@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Khem Raj <raj.khem@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57822 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752365AbdDMXh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:37:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B1B44C1097
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:37:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1328DA38C
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:37:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6CFADA385
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:37:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170410195804.18238-2-raj.khem@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 10, 2017 at 12:58:04PM -0700, Khem Raj wrote:
> clang ignores the visibility attribute if its not
> defined before the definition. As a result these
> symbols become hidden and consumers of this library
> fail to link due to these missing symbols

Also applied, thanks.
