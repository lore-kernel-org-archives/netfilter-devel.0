From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Sun, 05 Apr 2015 21:07:39 +0200
Message-ID: <552187FB.60904@ahsoftware.de>
References: <551FC211.6000907@ahsoftware.de> <1428145986-15421-1-git-send-email-holler@ahsoftware.de> <20150404115550.GA5832@salvia> <20150405113214.GA23433@acer.localdomain> <20150405121104.GD23433@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:57315 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbDETHu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 15:07:50 -0400
Received: from wandq.ahsoftware (p4FC37E09.dip0.t-ipconnect.de [79.195.126.9])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id AEF262C9C1CA
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Apr 2015 21:07:46 +0200 (CEST)
In-Reply-To: <20150405121104.GD23433@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 05.04.2015 um 14:11 schrieb Patrick McHardy:
> On 05.04, Patrick McHardy wrote:

>> Basically this involves splitting the expression types into lhs (non-const)
>> and rhs (const) parts. Keywords on the RHS side can be caught using an
>> error statement and deferred to resolution during runtime.

Sounds like trial and error. ;)

