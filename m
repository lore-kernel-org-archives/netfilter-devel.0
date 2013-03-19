From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 3/3] NFQUEUE: add --queue-cpu-fanout parameter
Date: Tue, 19 Mar 2013 17:07:35 +0100
Message-ID: <20130319160735.GC13505@imap.eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
 <20130319141606.304161536@eitzenberger.org>
 <1363703652.30419.11.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3CSQHn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:07:43 -0400
Content-Disposition: inline
In-Reply-To: <1363703652.30419.11.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

> Cool job! This CPU-based setup has proven to be really efficient on
> af_packet capture. I hope this will bring a performance boost to NFQ.
> 
> If possible, it could be interesting to be able to setup the balance
> parameter by using an option in the same way fail-open option:  
>        uint32_t flags = NFQA_CFG_F_FAIL_OPEN;
>        uint32_t mask = NFQA_CFG_F_FAIL_OPEN;
>        int r = nfq_set_queue_flags(qh, mask, flags);
> This way, it is possible to tune the system without changing the
> ruleset.
> 
> What do you think ?

seems like a good change to me.  I will add that as well!

