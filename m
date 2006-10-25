From: "Wilfried BARNAVON" <wbarnavon@on-fire.net>
Subject: Re: Daily svn snapshots now working again (was Re: patch-o-matic-ng
	stopped ?)
Date: Wed, 25 Oct 2006 21:49:33 +0200
Message-ID: <001201c6f86e$b39671b0$fa00a8c0@dolphin>
References: <1265.85.68.10.218.1161688632.squirrel@www.on-fire.net>
	<20061024113551.GN6045@sunbeam.de.gnumonks.org>
Reply-To: Wilfried BARNAVON <wbarnavon@on-fire.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	technique@on-fire.net
To: "Harald Welte" <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello Harald,
Thank you to have answered me so quickly. I gonna test that.

Good health to you too !

Wilfried


Harald Welte <laforge@netfilter.org> said:

On Tue, Oct 24, 2006 at 01:17:12PM +0200, Wilfried BARNAVON wrote:

> I was used to test new linux kernels with
> experimental patches for netfilter, and - oh surprise !- the last month
> patch-o-matic-ng archives are more and more little, and finally with a
> null content !

You can find the current patch-o-matic-ng repository at
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/

> What happens ? Is this the end of a centralized and structured
> iptables developpement ? Is there a break in the developpement team ?

patch-o-matic[-ng] alwayas was a collection of various contributions
from people around the net, not a form of centralized and structured
development

> Is there a secret replacement of netfilter that justifies this
> carelessness ?

nobody is careless.  you just seem to be the first person to report that
problem to me.

> Just a bug in the patch-o-matic-ng "tar-gz" generator ?

Exactly.  It's fixed now, please use the
ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/patch-o-matic-ng-20061024.tar.bz2
snapshot that I just created.

Cheers,

-- 
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
----- Original Message ----- 
From: "Harald Welte" <laforge@netfilter.org>
To: "Wilfried BARNAVON" <wbarnavon@on-fire.net>
Cc: <technique@on-fire.net>; "Netfilter Development Mailinglist" 
<netfilter-devel@lists.netfilter.org>; "Netfilter Mailinglist" 
<netfilter@lists.netfilter.org>
Sent: Tuesday, October 24, 2006 1:35 PM
Subject: Daily svn snapshots now working again (was Re: patch-o-matic-ng 
stopped ?)
