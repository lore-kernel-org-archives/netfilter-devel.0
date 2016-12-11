From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] iptables: on revision mismatch, do not call
 print/save
Date: Sun, 11 Dec 2016 20:55:07 +0100
Message-ID: <20161211195507.GA4829@salvia>
References: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753592AbcLKTzQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2016 14:55:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F2AFF7FC51
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:55:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E41E6DA843
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:55:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6D15DA729
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:55:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 08, 2016 at 05:16:41PM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Between revisions, the layout of xtables data may change completely.
> Do not interpret the data in a revision M with a module of revision N.

Applied, thanks Willem.
