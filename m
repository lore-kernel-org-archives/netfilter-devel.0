From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables symbols
Date: Sat, 19 Dec 2015 18:48:22 +0100
Message-ID: <20151219174822.GC1421@salvia>
References: <CAKHNQQG0AN5OiThvRJTXHOj5OmzO5UHtDqjn-RqbH5thw-EVkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54130 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015AbbLSRsa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 12:48:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2AA4224A0E6
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:48:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1D403DA809
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:48:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 368FCDA807
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:48:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQG0AN5OiThvRJTXHOj5OmzO5UHtDqjn-RqbH5thw-EVkg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 19, 2015 at 06:17:15PM +0530, Shivani Bhardwaj wrote:
> Hi,
> 
> What is nft symbol for the following?
> 
> on-port
> on-ip
> tproxy-mark
> 
> I'm doing translations for TPROXY.

There is no native support for TPROXY yet.
