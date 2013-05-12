From: Chris Boot <bootc@bootc.net>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 09:11:51 +0100
Message-ID: <518F4EC7.1050403@bootc.net>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net> <1368291713-40132-3-git-send-email-bootc@bootc.net> <20130511192150.GA10646@localhost> <518EA9B3.8050606@bootc.net> <20130512004852.GA11205@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:49523 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3ELIL4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 04:11:56 -0400
In-Reply-To: <20130512004852.GA11205@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/05/2013 01:48, Pablo Neira Ayuso wrote:
> On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
> [...]
>> Hi Pablo,
>>
>> I'd argue exactly the opposite point: that when you want multiple
>> instances a PID file can help you work out which is which.
> That new option may break existing setups with multiple instances.

My patch explicitly doesn't change the behaviour of existing
configurations. If you don't pass '--pidfile /path/to/file.pid', no pid
file is written and there is no change in how ulogd works.

>> My patch adds an option that takes a filename argument, so two
>> instances can write to two different PID files; grepping ps won't
>> easily tell you which instance is the correct one (without resorting
>> to grepping for command-line arguments).
> You can use pidof. Many other debian init scripts use it to obtain the
> process PID.

/usr/sbin/ulogd -d -c /etc/ulog/instance1.conf
pidof ulogd > /run/ulog/instance1.pid # => 1234
/usr/sbin/ulogd -d -c /etc/ulog/instance2.conf
pidof ulogd > /run/ulog/instance2.pid # => 1234 2345

The second pidof will list the pids of both instances of ulogd on the
system. Without looking at all of the other pid files for other
instances, how does it know which one was the one it just started?

Chris

-- 
Chris Boot
bootc@bootc.net

