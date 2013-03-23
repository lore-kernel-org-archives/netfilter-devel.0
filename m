From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 3/3] NFQUEUE: add --queue-cpu-fanout parameter
Date: Sat, 23 Mar 2013 20:52:56 +0100
Message-ID: <20130323195256.GN13505@imap.eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
 <20130319141606.304161536@eitzenberger.org>
 <1363703652.30419.11.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3CWTw6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 15:52:58 -0400
Content-Disposition: inline
In-Reply-To: <1363703652.30419.11.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

> If possible, it could be interesting to be able to setup the balance
> parameter by using an option in the same way fail-open option:  
>        uint32_t flags = NFQA_CFG_F_FAIL_OPEN;
>        uint32_t mask = NFQA_CFG_F_FAIL_OPEN;
>        int r = nfq_set_queue_flags(qh, mask, flags);
> This way, it is possible to tune the system without changing the
> ruleset.

Not sure how the FAIL_OPEN relates to the CPU fanout.  Do you want to
setup the CPU fanout (on, off) per queue?

 /Holger

