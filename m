From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Tue, 11 Jul 2006 23:29:34 +0200
Message-ID: <44B4183E.7010905@trash.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net> <44B40B4E.6080206@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <44B40B4E.6080206@shorewall.net>
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

Tom Eastep wrote:
> Patrick McHardy wrote:
> 
>>But you can do your iptables matching, mark matching packets
>>and filter on the mark within ebtables.
> 
> 
> I was afraid that's what you were going to suggest. If Shorewall was an
> appliance that only supported a limited set of configurations, I could entertain
> that approach; as it is, I'm not sure.
> 
> I'm going to issue a warning to my users that Shorewall support for
> bridge/firewalls may be discontinued in the future. If in the next six months, I
> can come up with code that is clean enough to go forward with, I'll rescind the
> announcement.

That sounds overly dramatic to me.

> So that I understand the playing field, --physdev-out will no longer be
> supported out of the FORWARD and OUTPUT chains (all tables); is that correct?

For locally generated traffic (-o br0), yes. This feature is going to
be removed, but I think it might be more useful to gather some data
among your users who actually needs this. I did some google-research
myself, and I wasn't able to find more then a handful of examples
of people actually using it this way. I certainly would be interested
in this data, if it really is needed by a significant larger amount
than I thought I will consider migation strategies stronger than
before. So far I'm not convinced that this really will pose a problem.
