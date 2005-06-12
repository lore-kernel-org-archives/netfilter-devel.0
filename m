From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_recent fixes
Date: Sun, 12 Jun 2005 16:47:46 +0200
Message-ID: <42AC4B12.2080508@trash.net>
References: <87ll6o1pbi.fsf@blackdown.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Stephen Frost <sfrost@snowman.net>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261886AbVFLOsJ@vger.kernel.org>
To: Juergen Kreileder <jk@blackdown.de>
In-Reply-To: <87ll6o1pbi.fsf@blackdown.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Juergen Kreileder wrote:
> I've had some ipt_recent rules acting strangely after an uptime of
> about 25 days.  The broken behavior is reproducible in the 5 minutes
> before the first jiffies roll-over right after booting too.
> 
> The cause of the problem is the jiffies comparision which doesn't work
> like intended if one of the last hits was more than LONG_MAX seconds
> ago or if the table of last hits contains empty slots and jiffies
> is > LONG_MAX.
> 
> This patch fixes the problem by using get_seconds() instead of
> jiffies.  It also fixes some 64-bit issues.

Thanks, I've added it to my 2.6.13 tree.
