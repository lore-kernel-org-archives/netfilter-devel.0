From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Adding element to interval map consumes entire memory
Date: Sun, 11 Dec 2016 20:28:07 +0100
Message-ID: <20161211192807.GA31470@salvia>
References: <044c1296-0e35-4224-459f-3482691a3462@tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Richard =?iso-8859-1?Q?M=F6rbitz?=
        <richard.moerbitz@tu-dresden.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753592AbcLKT2Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2016 14:28:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB4168CD8F
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:28:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6336A7E2D
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:28:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06D71A7E25
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:28:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <044c1296-0e35-4224-459f-3482691a3462@tu-dresden.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 11, 2016 at 03:20:16PM +0100, Richard Mörbitz wrote:
> Hello,
> 
> first of all: the build in use is the current master
> (c89a0801d07740eff531412fe35ea2c9faad82b0).
> 
> We have a test setup running which consists of one table ("nat2") and an
> interval mapping ("subnettoip") of the type ipv4_addr -> ipv4_addr. The
> mapping is quite large (~16000 elements). One requirement of the system
> is that elements can be added and deleted during runtime.
> 
> With that map constructed, adding a new element is not possible. NFT
> will terminate during reallocation, because no memory is left.
> 
> GDB trace:
> http://pastebin.com/s7eyNEsH
> 
> Valgrind leak check:
> http://pastebin.com/fkG5UQig
> 
> Note that the test machine only has 2 GB of RAM, 1.6 of which are
> consumed by nft. So one question is: is it even possible to have enough
> memory in the final system, such that the required operation can be
> performed?
> 
> The second question would be: why is it necessary to allocate that much
> memory? As I have found out by reading the code, all map elemtents are
> cached before performing the operation; they are even sorted. Is that
> really necessary for operations like adding map entries?

interval code is buggy, I remember to have seen a large memory
allocation being triggered in libgmp calls.

If you can hand over an example that I can use to reproduce I'd
appreciate, I understand this may require some confidentiality, so
feel free to send me a file with randomized addresses or such.

Thanks.
