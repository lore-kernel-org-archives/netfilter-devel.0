From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Created debian/ dir for dpkg-buildpackage
Date: Tue, 07 Nov 2006 13:55:31 +0100
Message-ID: <45508243.4050908@netfilter.org>
References: <454F7707.3010904@netfilter.org>
	<20061106193740.GA5251@galois.math.uni-paderborn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: max@rfc2324.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
 netfilter-ha@lists.netfilter.org
In-Reply-To: <20061106193740.GA5251@galois.math.uni-paderborn.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Max,

Maximilian Wilhelm wrote:
> Am Montag, den  6. November hub Pablo Neira Ayuso folgendes in die Tasten:
> 
>> Status:
> 
>> This project is under development, people feeling brave are encouraged
>> to test a send nice reports ;)
>  
> So far: It seems to work :)
> 
> I felt brave enough to create a debian like init.d script and a whole
> debian directory for the source tree to simplify building of conntrackd
> packages.

Thanks

> Also I wrote a little script to be used as heartbeat resource.d plugin
> which is included in the tar-ball as exmaple.

Interesting also for heartbeat users, although I prefer keepalived that
IMHO has a tighter integration with linux (through netlink sockets)
although I must confess that I don't know the current development status
of heartbeart.

> As a debian dir is included in the libnetfilter_conntrack and libnfnetlink
> tar-balls it thought this could be helpfull. :)
> 
> You can download the tarball of the debian/ dir at
>  http://files.rfc2324.org/conntrackd/
> 
> Pablo, would you include this in further versions?

I think so, I'm going to put this in the source tree as soon as I get
time to review it ;)

> Btw at
>  deb http://debian.rfc2324.org/debian sarge conntrackd
>  deb-src http://debian.rfc2324.org/debian sarge conntrackd
> you can download precompiled packages for sarge.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
