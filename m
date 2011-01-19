From: holger@eitzenberger.org
Subject: [patch 0/2] Ipset patches
Date: Wed, 19 Jan 2011 21:26:07 +0100
Message-ID: <20110119202607.532407993@eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:63016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1ASUgC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:36:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

what follows are two small patches which remove unneeded argv[]
loops when parsing the ipset commands.  They are in particular no
change in command line handling.

The command line handling can still be improved, as e. g.

 $ ipset -o xml create foo hash:ip
 $ ipset -s add foo 192.168.1.1

both work, but the options are just ignored.  And they don't
make much sense for either 'create' or 'add'.

Also we should consider to make the argument handling a little
more strict, as e. g.

 $ ipset -o xml list foo
 $ ipset list -o xml foo
 $ ipset list foo -o xml

all work.  By removing some of those possibilities it should even
get simpler code wise.

 /holger

-- 
