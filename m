From: Sven Schnelle <svens@bitebene.org>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Tue, 02 Oct 2007 19:22:24 +0200
Message-ID: <871wcd1lf3.fsf@apollo.sven.bitebene.org>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from woomax.duncanthrax.net ([195.2.162.46]:44307 "EHLO
	woomax.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbXJBRW1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:22:27 -0400
In-Reply-To: <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Fri\, 28 Sep 2007 16\:16\:49 +0200 \(CEST\)")
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

>>+	switch (c) {
>>+		unsigned int option;
>>+

Hmm, forgot to move that one. Still there :/

> Huh, what's that option doing there? It looks out of place.

> Try CodingStyle.

Damn, forgot once more to change my edit style in the editor - lets see
what else comes up. will submit the patch again with changed settings
if there are no other complains ;)
