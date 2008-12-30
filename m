From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables-save: restore indent after last change
Date: Tue, 30 Dec 2008 12:13:19 +0100
Message-ID: <495A024F.7060503@netfilter.org>
References: <alpine.LNX.1.10.0812242031570.514@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0812242032300.514@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56424 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751397AbYL3LNb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 06:13:31 -0500
In-Reply-To: <alpine.LNX.1.10.0812242032300.514@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent 67f4e55f28abf2f666c0a0aa874d9421e91d6184
> commit 5c79c4fa98e35426b836d468e80c3c5e7466ad8b
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Dec 24 20:32:26 2008 +0100
> 
> iptables-save: restore indent after last change

patching file iptables-save.c
Hunk #1 succeeded at 61 (offset 1 line).
Hunk #2 FAILED at 71.
1 out of 2 hunks FAILED -- saving rejects to file iptables-save.c.rej

Weird, this patch does not apply.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
