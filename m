From: Phil Oester <kernel@linuxace.com>
Subject: Re: Throttling by 'limit' in one chain fails whenever a *different*
	chain is modified
Date: Tue, 28 Dec 2004 12:59:51 -0800
Message-ID: <20041228205951.GA7990@linuxace.com>
References: <041228124435.278000@ime1.iment.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Paul Kosinski <prk@iment.com>
Content-Disposition: inline
In-Reply-To: <041228124435.278000@ime1.iment.com>
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

On Tue, Dec 28, 2004 at 12:44:34PM -0500, Paul Kosinski wrote:
> [Posting this to the general list got no response since Dec 15, so I'll try the developer list.]

Did you search the archives prior to posting?  That is generally
considered to be a good idea (as is wrapping lines at 80 characters).

> The problem I experience is that whenever the dynamic-rule script fires, I get a log entry for an established-tunnel packet. Since the first script fires N times per hour, I get N times as many log entries for the tunnel as I want. This makes my examination of the firewall log more tedious and error prone than it should be.

Please see this thread:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-September/016826.html

Phil
