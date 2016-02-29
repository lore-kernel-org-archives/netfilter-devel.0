From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype, meta: add new ifname_type for
 iifname/oifname
Date: Mon, 29 Feb 2016 14:12:02 +0100
Message-ID: <20160229131202.GA16476@salvia>
References: <1456514374-28827-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33192 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbcB2NMI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 08:12:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6C9BE4B9E7
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 14:12:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 58723DA386
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 14:12:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 40194DA386
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 14:12:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456514374-28827-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Feb 26, 2016 at 08:19:34PM +0100, Florian Westphal wrote:
> String is an unqualified type and we do not have a data element to
> derive the element size from at set creation time.
> 
> Add a new string subtype -- iface_name -- and switch
> meta iifname/oifname to use it instead of string.
> 
> One can then define a named set for interface names with
> 
> nft add set filter ifnames '{type iface_name; }'

The problem is that unqualified types cannot be currently used because
the have no specific length.

Carlos has been submitting patches for a while (he's on Cc) that it
would be great to see in the tree at some point this week. Basically,
he's introducing a TLV infrastructure to store metainformation in the
USERDATA area.

The idea is to use these new TLVs to include the length of this
datatype. This allows us to interpret the data when dumping it from
the kernel and transform it to object via set_delinearize().

I have an incomplete patch here, it is a hack, I need to port it on
top of Carlos' TLVs so we can use any unqualified type for set
definitions.

This will also resolve the use of concatenations with unqualified
datatypes too.

Thanks.
