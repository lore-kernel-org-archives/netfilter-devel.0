From: Dominik Kaspar <dokaspar.ietf@gmail.com>
Subject: Installing Xtables-Addons
Date: Fri, 12 Mar 2010 13:39:18 +0100
Message-ID: <2a3692de1003120439k75adfae3ie2bc484152c2b82b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45044 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab0CLMjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:39:20 -0500
Received: by bwz1 with SMTP id 1so984139bwz.21
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Mar 2010 04:39:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I tried installing the xtables-addons by first downloading it as follows:

git clone git://xtables-addons.git.sf.net/gitroot/xtables-addons/xtables-addons/

Then I read the INSTALL file, where it says to do this:

$ ./configure
$ make
# make install

However, "./configure" does not work: "bash: ./configure: No such file
or directory"
There is no file "configure" in the repository, only a "configure.ac".
I'm unfamiliar with "autotools"... what exactly is required to make
this work?

Regards,
Dominik
