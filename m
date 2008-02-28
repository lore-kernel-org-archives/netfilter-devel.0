From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: helpers register for a specific port, but work anyway
Date: Thu, 28 Feb 2008 11:46:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802281144470.4324@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802271534551.12047@blackhole.kfki.hu>
 <Pine.LNX.4.64.0802271758460.5388@fbirervta.pbzchgretzou.qr>
 <47C59A08.9080802@trash.net> <Pine.LNX.4.64.0802272346160.5388@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802280814270.14171@blackhole.kfki.hu>
 <Pine.LNX.4.64.0802281012020.4324@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802281039430.14348@blackhole.kfki.hu>
 <Pine.LNX.4.64.0802281135560.4324@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54114 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbYB1KqR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:46:17 -0500
In-Reply-To: <Pine.LNX.4.64.0802281135560.4324@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 28 2008 11:36, Jan Engelhardt wrote:
>>> The module was certainly loaded, otherwise `conntrack -E` would
>>> not have printed anything.
>>> No parameters were specified, just `modprobe nf_conntrack_ftp`,
>>> like I said. There is no way it should have analyzed port 2121 ftp.
>>
>>Any long forgotten nf_conntrack_ftp related option setting under 
>>/etc/modprobe.d/ or in /etc/modprobe.conf?
>
>I looked into /sys/module/nf_conntrack_ftp/parameters/ports
>which only contains "21". I'm gonna stacktrace it now...
>
Ok issue solved ... a stray DNAT in the *OUTPUT* chain
of the client. Man that one was hidden :) wonder when I added that.
Thanks.
