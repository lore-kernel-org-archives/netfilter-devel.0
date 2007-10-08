From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/13] Split Netfilter IPv4 defragmentation into a separate
 module
Date: Mon, 08 Oct 2007 10:30:16 +0200
Message-ID: <4709EA98.5040902@trash.net>
References: <20071002203942.11052.7303.stgit@nessa.odu> <20071002204349.11052.18611.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55828 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbXJHIcj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 04:32:39 -0400
In-Reply-To: <20071002204349.11052.18611.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> +void nf_defrag_ipv4_enable(void)
> +{
> +}
> +EXPORT_SYMBOL(nf_defrag_ipv4_enable);


A bit pointless for this function, but I'd prefer
EXPORT_SYMBOL_GPL for consistenty :)

