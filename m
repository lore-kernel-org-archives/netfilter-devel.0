From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: conntrack: support a fixed size of 128
 distinct labels
Date: Sat, 23 Jul 2016 12:27:19 +0200
Message-ID: <20160723102719.GA3162@salvia>
References: <1469098277-1227-1-git-send-email-fw@strlen.de>
 <1469098277-1227-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60669 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbcGWK12 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 06:27:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9BC59E7DA1
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:27:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DCDEFAB56
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:27:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8C6AD6DB36
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:27:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469098277-1227-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 21, 2016 at 12:51:16PM +0200, Florian Westphal wrote:
> The conntrack label extension is currently variable-sized, e.g. if
> only 2 labels are used by iptables rules then the labels->bits[] array
> will only contain one element.
> 
> We track size of each label storage area in the 'words' member.
> 
> But in nftables and openvswitch we always have to ask for worst-case
> since we don't know what bit will be used at configuration time.
> 
> As most arches are 64bit we need to allocate 24 bytes in this case:
> 
> struct nf_conn_labels {
>     u8            words;   /*     0     1 */
>     /* XXX 7 bytes hole, try to pack */
>     long unsigned bits[2]; /*     8     24 */
> 
> Make bits a fixed size and drop the words member, it simplifies
> the code and only increases memory requirements on x86 when
> less than 64bit labels are required.
> 
> We still only allocate the extension if its needed.

Applied, thanks.
