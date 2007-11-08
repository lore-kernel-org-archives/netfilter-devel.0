From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] iptables-restore: renames --test to --dry-run
Date: Thu, 8 Nov 2007 10:02:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711081001180.4330@fbirervta.pbzchgretzou.qr>
References: <47322D4A.3090201@endian.com> <20071107230852.GA3206@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Warasin <peter@endian.com>, netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53589 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbXKHJCO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:02:14 -0500
In-Reply-To: <20071107230852.GA3206@eychenne.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 8 2007 00:08, Herv=C3=A9 Eychenne wrote:
>
>- the -d option is generally used (as a debug switch). The one-letter
>  equivalent of --dry-run is generally -n.

-n is commonly used for "numeric", e.g. 134.76.13.21 for output
rather than linux01.org

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
