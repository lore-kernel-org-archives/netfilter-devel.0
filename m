From: Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>
Subject: Conntrack, expectations, debug
Date: Thu, 14 May 2009 12:56:26 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB2273C5F360@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from owa.ptinovacao.pt ([194.65.138.99]:42811 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbZENL46 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 May 2009 07:56:58 -0400
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear all,

I have read the documents "Writing Netfilter Modules" and "netfiler-hacking-HOWTO" and I still didn't understand how can I write a conntrack helper module in order to ignore the source address in incoming connection, is there any already written module with good documentation? Is there anyway to manually enter connections in the conntrack list? Just onde more question, is it possible to debug netfilter in order to see how the packets flow through the code?

Best Regards

Hugo Mendes