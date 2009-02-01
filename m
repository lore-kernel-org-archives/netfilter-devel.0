From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libxtables: prefix names and order #3
Date: Sun, 01 Feb 2009 22:39:10 +0100
Message-ID: <4986167E.70500@netfilter.org>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901271511190.13940@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901271523470.13940@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jamal <hadi@cyberus.ca>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39704 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753380AbZBAVjV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:39:21 -0500
In-Reply-To: <alpine.LSU.2.00.0901271523470.13940@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent 8759aeb8e8531f26df72ee15fbcab921ca4f361f (v1.4.3-rc1-24-g8759aeb)
> commit 1ec3f7612119d65d26d2774414ee92fdabec214a
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Jan 27 15:23:01 2009 +0100
> 
> libxtables: prefix names and order #3
> 
> This change affects:
> 	find_{match,target} -> xtables_find_{match,target}
> 	enum xt_tryload -> enum xtables_tryload
> 	loose flags like DONT_LOAD -> XTF_DONT_LOAD

Also applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
