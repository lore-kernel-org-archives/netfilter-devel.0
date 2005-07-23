From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sun, 24 Jul 2005 00:21:28 +0200
Message-ID: <42E2C2E8.8010900@gmx.net>
References: <42E1ADB2.1080109@trash.net>		<1122119412.4484.5.camel@localhost.localdomain>		<42E267C8.9090005@trash.net>	<1122148193.3382.16.camel@localhost.localdomain>
	<42E2A2E9.8050800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E2A2E9.8050800@trash.net>
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

Patrick McHardy schrieb:
> The problem is that we can't create two kernel sockets for the same
> netlink family. Netlink families are a scarce resource, so I don't think
> it makes much sense to waste another one for a soon (couple of days)
> deprecated mechanism. I propose to continue this discussion once the
> new code is there, so we can see if it fits your needs.

Please add ebt_ulog to Documentation/feature-removal-schedule.txt
and give people the usual 6 month grace period to transition to
the proposed feature-equivalent alternatives.

Regards,
Carl-Daniel
