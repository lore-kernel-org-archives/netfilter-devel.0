From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Wed, 25 May 2011 09:23:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105250916260.5929@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDC6240.7050701@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55793 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab1EYHXV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 03:23:21 -0400
In-Reply-To: <4DDC6240.7050701@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 25 May 2011, Mr Dash Four wrote:

> > Userspace changes:
> >  - Restore with bitmap:port and list:set types did not work, fixed
> >   
> Having had the chance to test this now, I can say that it works, and what's
> more - the loading performance is much, much better - all my sets now load in
> about 2-3 seconds, while with the 4.5 version it took in excess of 10 minutes,
> completely hogging my CPU in the process. I haven't had the chance yet to
> judge the matching performance, but this is what I will do in the coming days.
> 
> I have found a bug, however. :-\
> 
> When I have multiple sets of different type to restore, each restore file
> normally ends with "COMMIT" statement for ipset to commit the whole
> transaction, or so I thought. If there is a mistake (syntax or any other)
> somewhere in the restore file, which prevents the restore process, ipset
> already commits everything up to that point, which I think is wrong.
> 
> For example, if I have this:
> 
> n privileged-ports bitmap:port range 1-1023 timeout 0
> a privileged-ports 1-1023
> n test-ports bitmap:port range 12770-19999 timeout 0
> a test-ports 20000-30000
> a test-ports 19999
> n test-port bitmap:port range 29950-29950 timeout 0
> a test-port 29950
> COMMIT
> 
> There is an obvious error in line 4 above ("a test-ports 20000-30000" - this
> is out of the defined range for this set) - ipset should have aborted the
> whole transaction and not committed anything, but in practice,
> privileged-ports set is already registered and its members are already added.
> 
> Apart from the obvious error of ipset committing before the actual "COMMIT"
> has taken place, this raises another issue when I actually try to reload this
> file - I will get an error straight away as privileged-ports is already
> registered and that shouldn't be the case. Thought to let you know.

If you have got a restore file with an error in it, fix the file and 
restore it again but with the '-!' flag. That way all already defined 
sets, elements are ignored (technically: not raised the error due to the 
clashing set/elements):

# ipset restore < file
<syntax error, fix the file>
# ipset -! restore < file

The "COMMIT" string is not required at all in ipset 6.x. It's just kept 
for backward compatibility reasons.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
