From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bump version to 1.0.3
Date: Fri, 23 Jun 2017 10:52:16 +0200
Message-ID: <20170623085216.GA1370@salvia>
References: <20170621211846.20630-1-richard@nod.at>
 <8c83afe4-3947-13cb-0bbd-973ac8ef960f@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753759AbdFWIw0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2017 04:52:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0935D1B8408
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 10:52:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF13AA7F25
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 10:52:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC437DA46C
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 10:52:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <8c83afe4-3947-13cb-0bbd-973ac8ef960f@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 21, 2017 at 11:20:36PM +0200, Richard Weinberger wrote:
> Am 21.06.2017 um 23:18 schrieb Richard Weinberger:
> > Time to make a new version such that distros can pick this version.
> > Many distros ship only 1.0.2 which is almost five years old and
> > does not support recent netfilter features such as NFQA_CT.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> > Hi!
> > 
> > As discussed with Florian on IRC, it is time for a new version.
> > I think we don't have to change the API version, so just increment
> > the release version.

Will schedule time releases by next week.
