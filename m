From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] disallow multiple matches of same type
Date: Mon, 20 Feb 2006 10:31:22 -0800
Message-ID: <20060220183122.GA17077@linuxace.com>
References: <20060220055421.GA10552@linuxace.com> <43F9FE8E.5050607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43F9FE8E.5050607@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Feb 20, 2006 at 06:38:22PM +0100, Patrick McHardy wrote:
> I think Harald already did something in this direction. Harald?

He corrected it so iptables didn't segfault, and opened a new bug
for the incorrect behaviour.  This fixes that new bug.

Phil
