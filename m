From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: "Late REDIRECT"
Date: Mon, 13 Mar 2006 12:01:10 +0100
Message-ID: <441550F6.7060609@eurodev.net>
References: <44153615.50408@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Menno Smits <menno@netboxblue.com>
In-Reply-To: <44153615.50408@netboxblue.com>
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

Menno Smits wrote:
> Hi,
> 
> Just wanted to ask for your opinions on an idea. Please let me know if
> you think this is too difficult or crazy.
> 
> We use currently use the REDIRECT target in nat PREROUTING to send
> specific traffic to proxies running on our gateway (http, pop3, dns and
> smtp).
> 
> This works ok but we have the following problems:
> 
> 1) nat PREROUTING happens before filter FORWARD. If we want to apply
> consistent filter rules to outbound traffic regardless of whether it
> goes via a transparent proxy or directly out then we can't because the
> transproxied traffic never goes thru filter FORWARD. Currently we use a
> horrible system of marks set in mangle PREROUTING to work around this.
> We reject packets in FORWARD or skip the REDIRECTs in nat based on the
> marks set. This is ugly and hard to debug (esp because we also use marks
> for traffic shaping).
> 
> 2) Return traffic from the transparent proxy REDIRECTs has the source IP
> and source port of the transparent proxy listener, not the true remote
> site and port. This means that when we do accounting for return traffic
> (using ULOG in mangle POSTROUTING) the remote host and port are incorrect.
> 
> A possible solution to the above problems is to allow REDIRECTs to occur
> in nat POSTROUTING (a "late redirect" for want of a better term). That
> way all outbound traffic can pass through filter FORWARD before being
> REDIRECTed. The reply NAT for the late REDIRECT would work in a similar
> way, being performed before filter FORWARD so that the true source IP
> and port is seen there.
> 
> Is something like this feasible? How difficult would it be implement? Am
> I barking up the wrong tree?

Ick, this seems frigthening. Why don't you filter in the raw PREROUTING?

-- 
Pablo
