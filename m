From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: Allow dropping packet after call to
 l4proto->packet
Date: Thu, 12 Mar 2009 16:34:35 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903121634070.12067@fbirervta.pbzchgretzou.qr>
References: <200903121603.02733.christoph.paasch@gmail.com> <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60568 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZCLPej (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:34:39 -0400
In-Reply-To: <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-12 16:13, Christoph Paasch wrote:

>As NF_DROP = 0, no packets would ever have been dropped.

Mh would not it be safer to actually give NF_DROP a real value so that 
-NF_DROP also makes sense?
(Might need checking places where NF_DROP is used.)

