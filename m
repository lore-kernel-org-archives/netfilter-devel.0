From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Adding element to interval map consumes entire memory
Date: Thu, 15 Dec 2016 23:02:38 +0100
Message-ID: <20161215220238.GA25865@salvia>
References: <044c1296-0e35-4224-459f-3482691a3462@tu-dresden.de>
 <20161211192807.GA31470@salvia>
 <3acabb81-c5b5-2004-18ce-8b5242f07921@tu-dresden.de>
 <20161213004849.GA15100@salvia>
 <8fa4cbd2-5fb8-1189-302a-cf8be3c858be@tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Richard =?iso-8859-1?Q?M=F6rbitz?=
        <richard.moerbitz@tu-dresden.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754765AbcLOWCr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2016 17:02:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0464A7655
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 23:02:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E87D2DA862
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 23:02:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B30E8DA851
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 23:02:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <8fa4cbd2-5fb8-1189-302a-cf8be3c858be@tu-dresden.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Richard,

On Thu, Dec 15, 2016 at 12:52:01AM +0100, Richard Mörbitz wrote:
[...]
> I don't know how to contribute them properly, so I have attached four
> tests to this mail. They are based on
> sets/0013add_delete_many_elements_0, as
> sets/0012add_delete_many_elements_0 fails (it seems like adding and
> deleting elements simultaneously causes the whole ruleset to be empty).

We usually get patches, in the form of git-format-patch, but no
problem I have created a patch based on this tarball. You can now find
it at git.netfilter.org.

Thanks for making these four tests and confirming this bug is now gone!
