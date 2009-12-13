From: "Balaji Venkatamohan" <bvenkat@ncsu.edu>
Subject: Need help with inserting match extension files using xtables-addons
Date: Sat, 12 Dec 2009 19:16:31 -0500 (EST)
Message-ID: <4523.152.1.223.36.1260663391.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from uni13mr.unity.ncsu.edu ([152.1.224.171]:37496 "HELO
	uni13mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751952AbZLMB1f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:27:35 -0500
Received: from uni25wi.unity.ncsu.edu (uni25wi.unity.ncsu.edu [152.1.227.130])
	by uni13mr.unity.ncsu.edu (8.13.7/8.13.8/Nv5.2008.0610.1) with ESMTP id nBD0GWTf022822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2009 19:16:32 -0500 (EST)
Received: from uni25wi.unity.ncsu.edu (localhost.localdomain [127.0.0.1])
	by uni25wi.unity.ncsu.edu (8.13.8/8.13.8) with ESMTP id nBD0GWSb000404
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2009 19:16:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I am trying to install a new xtables match extension. Its a simple one
which I am coding for my understanding.

I am done with the coding for my kernel space '.c ' and '.h' files and am
also done with userspace 'libxt_*.c' file. As per the tutorial 'writing
netfilter modules', I am using xtable-addons to insert my module.

I am done with downloading the xtables-addons package. I also put my three
files in extensions/ folder. I have also made changes to Kbuild, Mbuild
and mconfig files. When I run the command './configure' from the
xtables-addons folder, I am getting the error after sometime stating the
following:

**************************************************************************
"checking for libxtables... configure: error: Package requirements
(xtables >= 1.4.3) were not met:

No package 'xtables' found

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

Alternatively, you may set the environment variables libxtables_CFLAGS
and libxtables_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details."
*************************************************************************
I know that my system does not have xtables.h in the /usr/include folder.
I also tried to download xtables.h from the internet. Strangely I was nt
able to find anything. Please help me with fixing the error and also do
tell me where I can find xtables.h header file.
Also is it enough that I do the above specified steps for using xtables
match extension.

Thanks
Balaji
