From: "Jaume Ribot Caner" <jaumerc@gmx.net>
Subject: Netfilter support for Sharp Zaurus
Date: Mon, 29 Sep 2003 16:51:29 +0200 (MEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <10345.1064847089@www17.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I have some trouble trying to add netfilter modules to the PDA Sharp Zaurus
5500. I have the linux kernel version linux-2.4.6-rmk1-np2-embedix, the one
used in the Zaurus. I have compiled the kernel (without errors) including the
corresponding netfilter support (all as modules). Then, I compiled the
modules (make modules) and then installed (make modules_install). Till here I have
all is working well. Then the problem is when copying the generated files to
the zaurus. I just copy all the .o files included in
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/ipv4/netfilter in the same place in the PDA. Then  I
tried to load the module, first executing the depmod and then calling the
instruction modprobe ip_queue. The following error is shown:

/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/core/netfilter.o: couldn't
find the kernel version the module was compiled for
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/core/netfilter.o: insmod
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/core/netfilter.o failed
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/core/netfilter.o: insmod
ip_queue failed

Ok, forcing to load with the right version insmod -f ip_queue gives the
following error:

Using
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/ipv4/netfilter/ip_queue.o
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/ipv4/netfilter/ip_queue.o:
unresolved symbol nf_register_queue_handler
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/ipv4/netfilter/ip_queue.o:
unresolved symbol nf_unregister_queue_handler
/lib/modules/2.4.6-rmk1-np2-embedix/kernel/net/ipv4/netfilter/ip_queue.o:
unresolved symbol nf_reinject
I don't understand why the dependencies are satisfied (depmod gives no
error) and then some function declaration is missing. Which can be the problem?
Any help will be helpfull

Thanks to all

Jaume Ribot

-- 
NEU FÜR ALLE - GMX MediaCenter - für Fotos, Musik, Dateien...
Fotoalbum, File Sharing, MMS, Multimedia-Gruß, GMX FotoService

Jetzt kostenlos anmelden unter http://www.gmx.net

+++ GMX - die erste Adresse für Mail, Message, More! +++
