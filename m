From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/10] [NETFILTER]: constify and annotate nf_conntrack_h323
Date: Wed, 30 Jan 2008 16:33:25 +0100
Message-ID: <47A098C5.8070509@trash.net>
References: <Pine.LNX.4.64.0801260236250.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54122 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYA3Pdm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:33:42 -0500
In-Reply-To: <Pine.LNX.4.64.0801260236250.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Constify data tables (predominantly in nf_conntrack_h323_types.c, but
> also a few in nf_conntrack_h323_asn1.c) and use const qualifiers on
> variables where possible in the h323 sources.

Applied, thanks.
