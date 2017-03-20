From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] parser_bison: Allow flushing flow tables
Date: Mon, 20 Mar 2017 11:15:18 +0100
Message-ID: <20170320101518.GA10209@salvia>
References: <20170317150316.GA1260@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56054 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753162AbdCTKPX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 06:15:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6EDFA2493C
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:15:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5EB98DA87A
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:15:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FAC7DA86C
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:15:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170317150316.GA1260@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 17, 2017 at 12:03:17PM -0300, Elise Lennion wrote:
> This patch enables the command flush on flow tables, which removes all
> entries in it:
> 
> $ nft flush flow table filter ft-https
> 
> Command above flushes flow table 'ft-https' in table 'filter'.

Applied, thanks Elise.
