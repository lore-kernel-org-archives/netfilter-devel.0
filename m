From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Sat, 20 Mar 2004 02:52:17 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403200251050.14515-100000@filer.marasystems.com>
References: <405B7A8C.6060306@nk.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <405B7A8C.6060306@nk.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 19 Mar 2004, Victor Julien wrote:

> > This line is redundant. You only need policy lines if you want to change 
> > the policy.
> 
> But i do need it if i want to (re)set chain counters, right?
> 
> Like this:
> :INPUT DROP [123:45678]

Yes.

Or if you don't the old counters should be kept.

Regards
Henrik
