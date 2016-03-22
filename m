From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-translate: translate iptables --flush
Date: Tue, 22 Mar 2016 19:45:06 +0100
Message-ID: <20160322184506.GA5789@salvia>
References: <20160318203549.GA18494@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36759 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbcCVSpO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 14:45:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EBE36C1240
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:45:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DF78EDA8F9
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:45:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAA87DA8F9
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:45:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160318203549.GA18494@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 19, 2016 at 02:05:49AM +0530, Guruswamy Basavaiah wrote:
> translation for iptables --flush 
> 
> Examples: $ sudo
>  iptables-translate -F INPUT nft flush chain ip filter INPUT
> 
> $ sudo iptables-translate -F -t nat
> nft flush table ip nat

Applied, thanks.
