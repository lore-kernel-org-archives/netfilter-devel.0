From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/2] tests: xlate: remove python 3.5 dependency
Date: Tue, 25 Apr 2017 11:00:01 +0200
Message-ID: <20170425090001.GA2382@salvia>
References: <1492557549-578-1-git-send-email-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37788 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1177033AbdDYJAL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:00:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 244DA80FE2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:00:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1582810218F
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:00:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5699BFF2DC
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 10:59:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492557549-578-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 19, 2017 at 01:19:08AM +0200, Pablo M. Bermudo Garay wrote:
> This commit replaces subprocess.run (introduced in python 3.5) with
> subprocess.Popen (supported since the first version of python 3).
> 
> Furthermore, the output has been improved when ip[6]tables-translate
> exits with non-zero return code.

Applied, thanks.
