From: Thomas Gelf <thomas@gelf.net>
Subject: Kernel panic (destroy_conntrack) unloading nf_conntrack_ftp before
Date: Fri, 10 Aug 2007 10:35:20 +0200
Message-ID: <f9h80e$uoo$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080203070704080205060109"
To: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------080203070704080205060109
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

that's my first "bug report" here, so please feel free to kick my ass
for whatever I'm doing wrong ;-)

Yesterday I experienced a kernel panic on 2.6.20.15-vs2.2.0.3-i686-smp
(vServer patch), caused by netfilter. I haven't been able to reproduce
it (and not been soooo desirous to do so) - but in my believes it has
been caused by the following steps:

* since some year we are using more or less the same kernel config to
   build debian kernel packages for most of our servers

* 2.6.20 "broke" our behaviour as all the nf-thingies have been renamed

* we have read a lot of docs, mails etc to really understand what's
   going on and modified our config accordingly

* we are using Shorewall on some servers (Debian Etch). Debian's
   Shorewall (3.2) contain's a /usr/share/shorewall/modules file without
   any knowledge about the 2.6.20 module names

* we substituted the modules file with a newer one (always 3.2) and
   commented out the SIP module (as I'm a bit sceptic about it, we are
   also running some SIP-Proxy-vServers)

* nf_conntrack_ftp has been loaded manually before as a customer
   complained about having problems with passive ftp

* later we REMOVED (rmmod) the (at this moment seeming to be unused)
   nf_conntrack_ftp module and restarted Shorewall (to see if it would
   correctly load all modules)

* PENG! Kernel panic (you can find an ugly "screenshot" attached to this
   mail)

I guess there may still have been active ftp sessions while unloading
the module, but even if that's the case in my believes either unloading
should be forbidden or netfilter should in some other way take care of
this - but NEVER panic.

Afterwards we did exactly the same thing (also modprobe / rmmod several
times) on three other servers, all of them running the same kernel,
shorewall and debian: no problem at all. The only difference was that
there has probably been no established ftp session.

Restarting the frozen server (including shorewall, loading the same
modules as before) was fine, also restarting shorewall more than once.

Kind regards,
Thomas Gelf


--------------080203070704080205060109--
