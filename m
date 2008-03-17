From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ipt_recent: sanity check hit count
Date: Mon, 17 Mar 2008 14:55:54 +0100
Message-ID: <47DE786A.7060301@trash.net>
References: <50136.192.168.101.12.1205588993.squirrel@intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	akpm@linux-foundation.org, skennedy@vcn.com
To: Daniel Hokka Zakrisson <daniel@hozac.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754293AbYCQOFB@vger.kernel.org>
In-Reply-To: <50136.192.168.101.12.1205588993.squirrel@intranet>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Daniel Hokka Zakrisson wrote:
> If a rule using ipt_recent is created with a hit count greater than
> ip_pkt_list_tot, the rule will never match as it cannot keep track
> of enough timestamps. This patch makes ipt_recent refuse to create such
> rules.


Applied, thanks.
