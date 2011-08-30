From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH RFC 2/3] netfilter: add ipv4 reverse path filter match
Date: Tue, 30 Aug 2011 15:53:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108301552010.17682@frira.zrqbmnf.qr>
References: <1314350465-19598-1-git-send-email-fw@strlen.de> <1314350465-19598-3-git-send-email-fw@strlen.de> <4E5CD8DA.1010204@trash.net> <20110830124119.GB7548@Chamillionaire.breakpoint.cc> <4E5CDB71.9080504@trash.net>
 <20110830125736.GD7548@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:32867 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1H3NxC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:53:02 -0400
In-Reply-To: <20110830125736.GD7548@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2011-08-30 14:57, Florian Westphal wrote:
>> 
>> Some modules already remove the const by casting it away, not
>> pretty, but works. Since the kernel doesn't assume strict aliasing
>> this also shouldn't cause any problems in the future. Alternatively
>> we can change the function signatures of course, although that would
>> be a bit unfortunate just for this special case.
>
>Agreed, modifying the match function signature for this case would be
>sad.
>
>I'll wait a couple of days and will send an updated version
>that uses the ugly cast + ip_route_input.

What could be done is:

struct xt_match {
	union {
		int (*match)(const struct sk_buff *, ...);
		int (*match_nonc)(struct sk_buff *, ...);
	};
};

falls into the same "ugh, what beauty" category :-)
