From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: arptables - max number of entries
Date: Tue, 6 Apr 2010 20:41:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004062037560.31132@obet.zrqbmnf.qr>
References: <1270563920.2712.25.camel@qed>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Gordon <peter@pg-consultants.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58228 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab0DFSlQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:41:16 -0400
In-Reply-To: <1270563920.2712.25.camel@qed>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-04-06 16:25, Peter Gordon wrote:

>Is there a maximum number of entries for arptables?

It depends on the memory fragmentation and the size of the largest 
single continuous memory chunk you have available at the time the table 
is updated.
