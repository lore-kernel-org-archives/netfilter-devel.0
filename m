From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sun, 24 Jul 2005 09:22:51 +0000
Message-ID: <1122196971.3382.6.camel@localhost.localdomain>
References: <42E1ADB2.1080109@trash.net>
	<1122119412.4484.5.camel@localhost.localdomain>
	<42E267C8.9090005@trash.net>
	<1122148193.3382.16.camel@localhost.localdomain>
	<42E2A2E9.8050800@trash.net> <42E2C2E8.8010900@gmx.net>
	<42E2D0C9.7080808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E2D0C9.7080808@trash.net>
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

Op zo, 24-07-2005 te 01:20 +0200, schreef Patrick McHardy:
> > Please add ebt_ulog to Documentation/feature-removal-schedule.txt
> > and give people the usual 6 month grace period to transition to
> > the proposed feature-equivalent alternatives.
> 
> It is _broken_ right now and conflicts with ipt_ULOG. There is no
> point in keeping it broken for 6 month.

Removing ebt_ulog would be stupid. So what if it conflicts with
ipt_ULOG, there is no kernel panic, they just can't be used together
currently. That problem should be solved by the generic replacement. To
say that ebt_ulog is broken is plain false.
If the "generic" replacement is such that it can only be used by
iptables modules then it is not generic at all.

Bart
