From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libxtables: prefix names and order it #1
Date: Sun, 01 Feb 2009 21:52:23 +0100
Message-ID: <49860B87.1090607@netfilter.org>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jamal <hadi@cyberus.ca>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35892 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752977AbZBAUwk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Feb 2009 15:52:40 -0500
In-Reply-To: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> As previously mentioned, libxtables needs some goodtime cleanup first.
> Now let me throw patches (unspecified number as of yet) at it-

Applied. Thanks. I have added a comment telling that this patch is
intended to fix Jamal's tc ipt dependencies with iptables.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
