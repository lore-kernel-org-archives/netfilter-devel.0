From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Changing destination ip and port of TEE'ed udp
Date: Tue, 9 May 2017 00:29:04 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1705090028280.1724@n3.vanv.qr>
References: <fbc2b521-5f4d-dc10-ee52-c17c5fbc810c@epmaki.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Yermakov <sergey@epmaki.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:43986 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdEHW3H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 18:29:07 -0400
In-Reply-To: <fbc2b521-5f4d-dc10-ee52-c17c5fbc810c@epmaki.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2017-05-09 00:22, Sergey Yermakov wrote:

> Hello,
>
> 1. Sorry if this has been already asked before ( couldn't find the answer in
> the archives) or the wrong list.
>
> 2. Changing the destination ip and port of TEE'ed udp datagrams seems doable
> and I was just wondering if there are some arguments against adding it to TEE.

It's not TEE's job to modify the packet - that's for DNAT left to do.
