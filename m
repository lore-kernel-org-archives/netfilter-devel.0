From: Msquared <1.list.netfilter@msquared.id.au>
Subject: Re: 'recent' matching when less than hitcount hits
Date: Mon, 2 Jul 2007 14:19:15 +0800
Message-ID: <20070702061915.GB6529@sliderule.msquared.com.au>
References: <20070627090043.GC31525@sliderule.msquared.com.au>
	<20070627094145.GB4288764@metu.edu.tr>
	<20070627090043.GC31525@sliderule.msquared.com.au>
	<468228DA.2040809@trash.net>
	<20070628040348.GD31525@sliderule.msquared.com.au>
	<4684F9C7.4080603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <4684F9C7.4080603@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 29, 2007 at 02:23:35PM +0200, Patrick McHardy wrote:

> >>>The rules are in a chain that is only hit for incoming SSH connections.
> >>>EG: I have this rule in the INPUT chain:
> >>>
> >>>  -m tcp --dport 22 -j service-ssh
> >>
> >>You are sending all the traffic to the port 22. Use -m state --state
> >>NEW, so that only new ssh connections can be updated. 
> > 
> > 
> > I already tried that, but it made no difference (perhaps because -m state
> > --state ESTABLISHED,RELATED -j ACCEPT higher in the INPUT chain).
> > 
> > Note from the iptables -vnL output that I showed that it only counted one
> > hit on the --set rule and a number of hits on the --update rule.
> 
> 
> I think I know what the reason is. My rewritten version of the recent
> match matches if the current packet is the nth hit and in that case
> doesn't note the entry. So you're only seeing n-1 entries in /proc.

I'm not sure if that's relevant or not.  Are you basing that on there
being 4 hits listed in my /proc output, whereas I have the hitcount at 5?

The problem persists even with the hitcount at 10.  Actually, it seems to
continue to misbehave up until 20, but seems to behave at 21 or higher
(with --seconds 40).

If my second attempt to connect is more than 40 seconds after the first,
it connects OK, but if it's less than 40 seconds after the first, it won't
let me connect.  It's as if it's ignoring the hitcount unless it's higher
than 20.

I tried with --seconds 30 and could find no correlation to the duration of
time between first and second attempts and whether the second attempt was
successful or not.

It's as if I just don't understand the interaction between --seconds and
--hitcount.  I believe they interact like so:

  If there have been [hitcount] packets from the source IP in the last
  [seconds] seconds, then the rule will match

Is this correct?

> Did the old version behave differently here?

I'm not sure, I've only ever had this version set up.

Regards, Msquared...
