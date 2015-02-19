From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 7/7] extensions: libip6t_dst: make inversion work
Date: Thu, 19 Feb 2015 14:43:10 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1502191441260.28372@nerf60.vanv.qr>
References: <1424351483-27617-1-git-send-email-fw@strlen.de> <1424351483-27617-8-git-send-email-fw@strlen.de> <alpine.LSU.2.11.1502191432250.27892@nerf60.vanv.qr> <20150219133721.GB24297@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares61.inai.de ([5.9.23.85]:46941 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753005AbbBSNnM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:43:12 -0500
In-Reply-To: <20150219133721.GB24297@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2015-02-19 14:37, Florian Westphal wrote:
>Interesting, --help does mention it:
>dst match options:
>[!] --dst-len length            total length of this header

Um, I got confused by your change to dst-opts related code:

>>>
 		opts[i] = (parse_opts_num(cp, "opt") & 0xFF) << 8;
                 if (range) {
 			if (opts[i] == 0)
 				xtables_error(PARAMETER_PROBLEM,
 					"PAD0 hasn't got length");
 			opts[i] |= parse_opts_num(range, "length") & 0xFF;
-                } else
+		} else {
                         opts[i] |= (0x00FF);
+		}
<<<

All in order. But perhaps separate style changes from real changes
commit-wise.
