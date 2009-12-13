From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Need help with inserting match extension files using
 xtables-addons
Date: Sun, 13 Dec 2009 02:30:45 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912130228360.8607@obet.zrqbmnf.qr>
References: <4523.152.1.223.36.1260663391.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Balaji Venkatamohan <bvenkat@ncsu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42306 "HELO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933462AbZLMBar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:30:47 -0500
In-Reply-To: <4523.152.1.223.36.1260663391.squirrel@webmail.ncsu.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-12-13 01:16, Balaji Venkatamohan wrote:

>Hi, I am trying to install a new xtables match extension. Its a simple one
>which I am coding for my understanding.
>
>**************************************************************************
>"checking for libxtables... configure: error: Package requirements
>(xtables >= 1.4.3) were not met:
>*************************************************************************
>I know that my system does not have xtables.h in the /usr/include folder.

Directory.

>I also tried to download xtables.h from the internet.

Well that will not fix it.
The book does states that iptables(-devel) 1.4.3 is needed beforehand.
It does not say -devel, but the prerequisite (also mentioned in the
book) is knowledge of C programming and your own system.

