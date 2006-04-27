From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: firewall with failover - ct_sync ?
Date: Thu, 27 Apr 2006 21:10:05 +0200
Message-ID: <20060427191005.GA7436@galois.math.uni-paderborn.de>
References: <1145895856.444cfbb0eee53@webmail.alinto.com>
	<20060424164204.GA21760@galois.math.uni-paderborn.de>
	<1146157094.4450f8263e46c@webmail.alinto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <1146157094.4450f8263e46c@webmail.alinto.com>
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

Am Donnerstag, den 27. April hub octane indice folgendes in die Tasten:

Hi!

> > > 2. b) Where I grab the patch files?

> > For 2.6:
> > http://svn.netfilter.org/netfilter/branches/netfilter-ha/

> Ok. I have to learn subversion first.
> I just know the CVS way or patch way to patch sources.

svn co  http://svn.netfilter.org/netfilter/branches/netfilter-ha/
It does just copy the repository to your disk.

> I should patch _two_ times?
> Let's take an example:

> I download linux-2.6.16, then patch with 
> http://svn.netfilter.org/netfilter/branches/netfilter-ha/
> then patch with the 
> http://vvv.barbarossa.name/files/ct_sync/ct_sync_2.6.16-fix.patch

The other way around.

The patches from svn.netfilter.org do not apply on linux-2.6.16.

 1. get http://svn.netfilter.org/netfilter/branches/netfilter-ha/
 2. patch it with my patch
 3. run quilt / patch the kernel
 4. build kernel

> > I only know of a german Linux-Magazin article at
> > http://www.linux-magazin.de/Artikel/ausgabe/2005/12/linux-ha-fw/linux-ha-
> > fw.html

> I don't speak german, I'll try to get it with google translate

Ok.

> > ct_sync expects an ethernet interface for syncing.
> > You cannot use anything different.

> PLIP is an ethernet link (sort of). If name "plip" is a 
> problem, is there a way to cheat it with udev?

It don't know if this will work.
Just try it :)

Ciao
Max
-- 
|           |                 Follow the white penguin.
|  |\/|  |  |-----------------------------------------------------------.
|  |  |/\|  |  Rechnerbetrieb Mathematik  |   Meine Baustellen:  TSM    |
|           |  Universitaet Paderborn     |   Hostmaster, Linux, LDAP   | 
