From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] netfilter: xt_u32: fix length checks in u32_match_it
Date: Thu, 16 Aug 2007 16:32:27 +0200
Message-ID: <46C45FFB.3050609@trash.net>
References: <exportbomb.1187270320@pinky> <3a5bf48d1567d7136baaac80dfa4c94f@pinky>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	netfilter-devel@lists.netfilter.org
To: Andy Whitcroft <apw@shadowen.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762823AbXHPOdf@vger.kernel.org>
In-Reply-To: <3a5bf48d1567d7136baaac80dfa4c94f@pinky>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Andy Whitcroft wrote:
> It seems an extraneous trailing ';' has slipped into the skb length
> checks in u32_match_it() triggering an unconditional missmatch.


Thanks, this already fixed in net-2.6 and should hit Linus' tree soon.
