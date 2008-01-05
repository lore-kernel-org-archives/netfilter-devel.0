From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd won't start, "can't open multicast server!"
Date: Sat, 05 Jan 2008 15:31:24 +0100
Message-ID: <477F94BC.40804@netfilter.org>
References: <20080104081007.GA30807@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44827 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752862AbYAEObp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:31:45 -0500
In-Reply-To: <20080104081007.GA30807@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Max,

Max Kellermann wrote:
> I am currently working on the official conntrack-tools 0.9.5 Debian
> package; I have been maintaining the old "conntrack" program before.
> The daemon will not start (with examples/stats/conntrackd.conf):
> 
>  host:~# /usr/sbin/conntrackd -C /etc/conntrackd.conf 
>  Notice: StripNAT clause is obsolete. Please, remove it from conntrackd.conf
>  ERROR: conntrackd cannot start, please check the logfile for more info
>  host:~# tail /var/log/conntrackd.log 
>  [Fri Jan  4 09:01:25 2008] (pid=9353) --- starting in console mode ---
>  [Fri Jan  4 09:01:25 2008] (pid=9353) [FAIL] can't open multicast server!
>  [Fri Jan  4 09:01:25 2008] (pid=9353) [FAIL] initialization failed

You forgot the -S option to run it in statistics mode. I know that this
option is a bit confusing so I have applied a patch to obsolete it.
Thus, you won't need to pass -S to conntrackd anymore in the upcoming
0.9.6 release.

> Also, the example shipped in the 0.9.5 includes the obsolete
> "StripNAT" option.

This was removed from SVN. BTW, SVN currently contains a patch to enable
logging via file/syslog for the statistics mode. Still, this requires
evaluation in terms of performance (e.g. very busy firewalls) and some
kind of tool that digest the logging information.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
