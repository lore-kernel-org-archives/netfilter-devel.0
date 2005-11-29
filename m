From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RESEND][PATCH] Recent match jiffies wrap mismatches
Date: Tue, 29 Nov 2005 15:51:59 -0800
Message-ID: <20051129235159.GA3680@linuxace.com>
References: <20051129050813.GA30630@linuxace.com> <438CDE4E.8070006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <438CDE4E.8070006@trash.net>
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

On Wed, Nov 30, 2005 at 12:03:42AM +0100, Patrick McHardy wrote:
> Applied, thanks. The lines just above that have the same problem, don't
> they?

No, since we aren't comparing to values which have been memset to zero.
We are comparing against last_seen + seconds, which will be a legitimate
value. 

> [slightly reformated for better readability]

(this file could seriously use a pass through Lindent)

Phil
