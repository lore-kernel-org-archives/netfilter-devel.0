From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: extensions: libxt_TEE: Add translation to nft
Date: Mon, 28 Mar 2016 12:31:58 +0200
Message-ID: <20160328103158.GA4200@salvia>
References: <1458733372-2543-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Roberto =?iso-8859-1?Q?Garc=EDa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbcC1KcH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 06:32:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E94F0E8396
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 12:32:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A272ADA8FA
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 12:32:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DE14DA385
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 12:32:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458733372-2543-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Roberto,

On Wed, Mar 23, 2016 at 12:42:52PM +0100, Roberto Garc=EDa wrote:
> Add translation for TEE target to nft.

I have applied this with minor glitches, thanks, comment below.

> However, there is a problem with the output when using
> ip6tables-translate. I couldn't find a fix for that.

Just pushed a patch to fix this problem, thanks.

> Examples:
>=20
> $ iptables-translate -t mangle -A PREROUTING -j TEE --gateway 192.168=
=2E0.2 --oif
> eth0
>=20
> nft add rule ip mangle PREROUTING counter dup to 192.168.0.2 oif eth0

We should use device instead of 'oif' for this translation.

BTW, I have also resolved trailing whitespace errors when applying
this patch, please enable some trailing whitespace highlighter in your
editor.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
