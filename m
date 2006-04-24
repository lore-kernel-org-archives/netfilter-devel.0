From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: firewall with failover - ct_sync ?
Date: Mon, 24 Apr 2006 18:42:04 +0200
Message-ID: <20060424164204.GA21760@galois.math.uni-paderborn.de>
References: <1145895856.444cfbb0eee53@webmail.alinto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <1145895856.444cfbb0eee53@webmail.alinto.com>
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

Am Montag, den 24. April hub octane indice folgendes in die Tasten:

Hi!

> I'm trying to experiment a firewall cluster under linux like 
> carp+pfsync under openBSD.

> 1. does ct_sync works?

Yes, at least for me :)
See below.

> I asked on the netfilter-failover mailing list where someone tolds me not (but 
> the mailing lists seems abandoned).

> 2. I found the web page:
> http://svn.netfilter.org/netfilter/trunk/netfilter-ha/README
> But it makes references to kernel 2.4.26 and CVS.



> 2. a) Must I use quilt? 

quilt does just apply add the patch files listed in the series file in
the order listed there. You can do this manually if you like (or
dislike quilt).

> 2. b) Where I grab the patch files?

For 2.4:
http://svn.netfilter.org/netfilter/trunk/netfilter-ha/patches/

For 2.6:
http://svn.netfilter.org/netfilter/branches/netfilter-ha/

(My patches are against the "normal" ct_sync version found in the
 "linux-2.6" subdirectory of the link above.)

I did not get the linux-2.6-multigroup stuff running stable with the
latest kerne up to now. Maybe I'll put my lasting patches for a
running-but-unstable-version to the webpage these days.

> 3. Is there another documentation?

I only know of a german Linux-Magazin article at
http://www.linux-magazin.de/Artikel/ausgabe/2005/12/linux-ha-fw/linux-ha-fw.html

> 4. the site http://vvv.barbarossa.name/files/ct_sync/
> gives two patch for the 2.6.16 kernel.
> Which one have I to use? both?

I thought the description beneath the file list was clear :)

I split up the patch so everyone can easily see what I've done to get it
working (-fix one) and what I did to make the sourcecode "look and feel"
a bit nicer (-cleanup one).
So if you just want a working version of ct_sync with a kernel version
2.6.16 (does work with 2.6.16.9 for me) you only have to patch your svn
copy from http://svn.netfilter.org/netfilter/trunk/netfilter-ha/ with
http://vvv.barbarossa.name/files/ct_sync/ct_sync_2.6.16-fix.patch

> 5. The link beetween the two machines must be an ethernet link? 
> I have old boxes with two PCI port only, but parrallel link is OK with plip. 
> For testing would it be OK? (I just want to test functionnality,
> not the throughput)

ct_sync expects an ethernet interface for syncing.
You cannot use anything different.

If you have switches which allow vlans (802.1Q) you could set up two (or
more) vlans and configure virtual interfaces on the firewall using
vconfig. (I've done so on my first firewalls using ct_sync as they have
only two interfaces, too).

HTH
Ciao
Max
-- 
|           |                 Follow the white penguin.
|  |\/|  |  |-----------------------------------------------------------.
|  |  |/\|  |  Rechnerbetrieb Mathematik  |   Meine Baustellen:  TSM    |
|           |  Universitaet Paderborn     |   Hostmaster, Linux, LDAP   | 
