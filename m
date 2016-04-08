From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Printing the table name before chain name.
Date: Fri, 8 Apr 2016 12:24:25 +0200
Message-ID: <20160408102425.GA2837@salvia>
References: <1460057894-20466-1-git-send-email-guru2018@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37837 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbcDHKYf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 06:24:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E13A213C0DA
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:24:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CD9E9DA390
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:24:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BA928DA38C
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:24:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460057894-20466-1-git-send-email-guru2018@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 08, 2016 at 01:08:14AM +0530, Guruswamy Basavaiah wrote:
> Command ./iptables-restore-translate, was printing
> table name before the chain name for user added chains.
> This is breaking ./nft -f command.
> 
> Before fix, output of "./iptables-restore-translate"
> add chain ip OUTPUT_direct raw
> 
> After fix:
> add chain ip raw OUTPUT_direct

Applied, thanks.
