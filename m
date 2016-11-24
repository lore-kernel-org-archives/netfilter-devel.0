From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 lnf-log] utils: nf-log: attaching a conntrack
 information
Date: Thu, 24 Nov 2016 12:54:27 +0100
Message-ID: <20161124115427.GA12366@salvia>
References: <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031535.GG7380@gmail.com>
 <20151012152630.GC21781@salvia>
 <20151015043544.GA18814@gmail.com>
 <20151015043925.GB18814@gmail.com>
 <20151016165908.GA5588@salvia>
 <20161115073602.GA10113@gmail.com>
 <20161115073815.GB10113@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49616 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932469AbcKXLyf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 06:54:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6CA01B360D
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:54:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6CA8A7D53
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:54:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71040A7D47
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:54:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161115073815.GB10113@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 04:38:16PM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch enables nf-log in utils directory to show conntrack
> information if libnetfilter_conntrack exists.

Applied, thanks Ken-ichirou.

We got already one user asking for this, so this is useful :)
