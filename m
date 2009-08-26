From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Wed, 26 Aug 2009 14:55:29 +0200
Message-ID: <4A9530C1.50200@trash.net>
References: <4A93D817.4080706@trash.net> <4A94073B.80106@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40235 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbZHZMza (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:55:30 -0400
In-Reply-To: <4A94073B.80106@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pascal Hambourg wrote:
> Hello,
> 
> May I ask what are the reasons for a helper to drop packets ?

Mainly parsing errors, memory allocation errors and bugs.
