From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: add test case for inserting element
 into verdict map
Date: Sun, 4 Dec 2016 21:28:05 +0100
Message-ID: <20161204202805.GA30778@salvia>
References: <1478617597-13459-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo@debian.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDU2O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:28:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E40C6B6C84
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:28:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5F67DA843
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:28:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0811DA849
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:28:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478617597-13459-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 08, 2016 at 11:06:37PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> "dalegaard@gmail.com" reports that when inserting an element into a
> verdict map, kernel crash will happen. Now add this test case so we
> can avoid future regressions fail.

Applied, thanks Liping.
