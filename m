From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 11:34:05 +0200
Message-ID: <20130512093405.GA12095@localhost>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
 <1368291713-40132-3-git-send-email-bootc@bootc.net>
 <20130511192150.GA10646@localhost>
 <518EA9B3.8050606@bootc.net>
 <20130512004852.GA11205@localhost>
 <518F4EC7.1050403@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43307 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3ELJeL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 05:34:11 -0400
Content-Disposition: inline
In-Reply-To: <518F4EC7.1050403@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Chris,

On Sun, May 12, 2013 at 09:11:51AM +0100, Chris Boot wrote:
> On 12/05/2013 01:48, Pablo Neira Ayuso wrote:
> > On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
> > [...]
> >> Hi Pablo,
> >>
> >> I'd argue exactly the opposite point: that when you want multiple
> >> instances a PID file can help you work out which is which.
> > That new option may break existing setups with multiple instances.
> 
> My patch explicitly doesn't change the behaviour of existing
> configurations. If you don't pass '--pidfile /path/to/file.pid', no pid
> file is written and there is no change in how ulogd works.

Existing setups having already two ulogd2 instances will break, as
they won't be passing --pidfile, thus clashing on the same default pid
file. One of the instances will not proceed. They will have to add
--pidfile to their scripts to get things back working.

> >> My patch adds an option that takes a filename argument, so two
> >> instances can write to two different PID files; grepping ps won't
> >> easily tell you which instance is the correct one (without resorting
> >> to grepping for command-line arguments).
> >
> > You can use pidof. Many other debian init scripts use it to obtain the
> > process PID.
> 
> /usr/sbin/ulogd -d -c /etc/ulog/instance1.conf
> pidof ulogd > /run/ulog/instance1.pid # => 1234
> /usr/sbin/ulogd -d -c /etc/ulog/instance2.conf
> pidof ulogd > /run/ulog/instance2.pid # => 1234 2345
> 
> The second pidof will list the pids of both instances of ulogd on the
> system. Without looking at all of the other pid files for other
> instances, how does it know which one was the one it just started?

You don't need to know. Assuming these possible actions:

/etc/init.d/ulogd2 {start|stop|restart|reload|force-reload|status}

if you want to support multiple instances in your script, the action
should apply to all of them.

But anyway, I suggest that that the standalone debian installation
sticks to one single instance at the same time, that's just fine for
most people.

Regards.
