From: "IKA SysAdmin" <ikaadmin@ethz.ch>
Subject: iptables cut specific connections when lots of files are commited via subversion
Date: Thu, 27 Nov 2008 09:53:24 +0100
Message-ID: <13685F7ECF97C14081E83FC0EC90853A3EC7E7@EX5.d.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from xsmtp0.ethz.ch ([82.130.70.14]:2132 "EHLO XSMTP0.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbYK0JIj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:08:39 -0500
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,
I had a problematic experience with iptables and thought, you might be interested.
regards, Claudia


Server FSC RX300, 8GB Memory
Red Hat Enterprise Linux Server release 5.2 (Tikanga)
Kernel 2.6.18-92.1.13.el5 #1 SMP Thu Sep 4 03:51:21 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux
Diskspace 175GB free out of 185GB (mirrored)
2 network cards
- one for "internal" use that provides samba shares
- one for "external" use that provieds access to the subversion system
the server is in a university campus in a virtual networkzone, but the filters there are open to my servers. 

apache httpd 2.2.3-11
subversion 1.4.2-2
iptables 1.3.5-4
iptables-ipv6 1.3.5-4

iptables added (created with firewall builder 3), only certain networks have access on the port 443, some on the samba shares on the server and some on the ssh port, everything else is closed down.
cronjob, that refreshed the firewall builder iptables all 15min. (*/15 * * * * /bin/sh /etc/firewall/IkaFw.fw > /dev/null)
svn clients mostly with tortoise over https port

Problem with subversion:
- commits and updates worked, but only with few files. As soon as somebody commited lots of files, the connection got lost.
- to make it more problematic, the https port was not available anymore from at last two subnets (one of them outside the virtual network of the campus), but it was still available from within the same subnet as the server is and from another subnet outside the virtual network of the campus
- on the server everything looked fine, httpd running, no errors in logfiles - but it wasn't accessible from all networks anymore
- after a reboot of the server, everything worked again - until somebody committed lots of files again
- after trying some things, I stopped iptables and we were able to commit lots of files
- also the flushing of the iptables helped - for one big commit, afterwards the server wasn't accessible anymore from most of the outside networks
- The use of the sambashare didn't produce any errors, we were able to load lots of heavy files on that share.

So I disabled the iptables and setup an external firewall box - 
some developpers now commited large sums of files and the error didn't occur anymore.
