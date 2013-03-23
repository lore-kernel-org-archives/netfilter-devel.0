From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH RFC 3/3] NFQUEUE: add --queue-cpu-fanout parameter
Date: Sat, 23 Mar 2013 22:53:49 +0100
Message-ID: <1364075629.4349.11.camel@tiger2>
References: <20130319141442.150005875@eitzenberger.org>
	 <20130319141606.304161536@eitzenberger.org>
	 <1363703652.30419.11.camel@tiger2>
	 <20130323195256.GN13505@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:33282 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3CWVx6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 17:53:58 -0400
In-Reply-To: <20130323195256.GN13505@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, 2013-03-23 at 20:52 +0100, Holger Eitzenberger wrote:
> Hi Eric,
> 
> > If possible, it could be interesting to be able to setup the balance
> > parameter by using an option in the same way fail-open option:  
> >        uint32_t flags = NFQA_CFG_F_FAIL_OPEN;
> >        uint32_t mask = NFQA_CFG_F_FAIL_OPEN;
> >        int r = nfq_set_queue_flags(qh, mask, flags);
> > This way, it is possible to tune the system without changing the
> > ruleset.
> 
> Not sure how the FAIL_OPEN relates to the CPU fanout.  Do you want to
> setup the CPU fanout (on, off) per queue?

You are right on a major point. FAIL_OPEN is definitely per-queue and
CPU fanout is related to a fanout group. So we will have to have the
whole mechanism bind to a queue, warn the kernel that it is in a fanout
group...

That could be interesting as we will be able to tune the setting from
the application but this seems to be a lot of work too. And I don't see
any functional benefit omit this tuning from the application.

So, if you don't find any other one, forgot my request for now :)

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

