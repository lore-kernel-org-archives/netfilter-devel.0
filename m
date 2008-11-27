From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables cut specific connections when lots of files are commited
 via subversion
Date: Thu, 27 Nov 2008 13:11:04 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811271308560.9403@fbirervta.pbzchgretzou.qr>
References: <13685F7ECF97C14081E83FC0EC90853A3EC7E7@EX5.d.ethz.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: IKA SysAdmin <ikaadmin@ethz.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52977 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYK0MLH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:11:07 -0500
In-Reply-To: <13685F7ECF97C14081E83FC0EC90853A3EC7E7@EX5.d.ethz.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-11-27 09:53, IKA SysAdmin wrote:

>Hi there,
>I had a problematic experience with iptables and thought, you might be interested.
>regards, Claudia

I'd be interested in the ruleset.

>iptables added (created with firewall builder 3), only certain
>networks have access on the port 443, some on the samba shares on
>the server and some on the ssh port, everything else is closed down.
>cronjob, that refreshed the firewall builder iptables all 15min.
>(*/15 * * * * /bin/sh /etc/firewall/IkaFw.fw > /dev/null) svn
>clients mostly with tortoise over https port
>
>Problem with subversion:
>
>* commits and updates worked, but only with few files. As soon as
>  somebody commited lots of files, the connection got lost.

>* to make it more problematic, the https port was not available
>  anymore from at last two subnets (one of them outside the virtual
>  network of the campus), but it was still available from within the
>  same subnet as the server is and from another subnet outside the
>  virtual network of the campus

>* on the server everything looked fine, httpd running, no errors in
>  logfiles - but it wasn't accessible from all networks anymore

>* after a reboot of the server, everything worked again - until
>  somebody committed lots of files again

>* after trying some things, I stopped iptables and we were able to
>  commit lots of files

>* also the flushing of the iptables helped - for one big commit,
>  afterwards the server wasn't accessible anymore from most of the
>  outside networks

Must have been your cron script reloading the ruleset.

>* The use of the sambashare didn't produce any errors, we were able
>  to load lots of heavy files on that share.

That's because SVN over http issues, I believe, one request
per file. If it does not use HTTP pipelining, that means
one connection per file. Which is likely to be detected as a DoS
attack. Hooray for svn  -.-

