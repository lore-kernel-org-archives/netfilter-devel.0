From: Gregor Maier <gregor@net.in.tum.de>
Subject: libnetfilter_log and libnetfilter_queue bind_pf() issue
Date: Fri, 24 Feb 2006 23:13:16 +0100
Message-ID: <43FF84FC.1070405@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,


I was wondering if nfq_bind_pf() and nflog_bind_pf() should really
return an errno of EEXISTS if the handlers from libnetfilter_queue.ko
and libnetfilter_log.ko have already been registered. From the viewpoint
of the userspace app only errors of EBUSY are of interest, since it
means that another handler is registered.

I would suggest to change libnetfilter_queue and libnetfilter_log
modules to only return an error if EBUSY was encountered.

Furthermore I think that a userspace app should never use
nfq_unbind_pf() followed by nfq_bind_pf() to initialize itself. If
packets arrive between the two calls, they will be overseen, since no
handler is present (think of process being scheduled between the two
calls and another app waiting for packets).

I also don't think that any module should unregister the handler from
another module. Esp. not with a function available from userspace...


Maybe a nice solution would be:

- - The modules (libnetfilter_log and libnetfilter_queue) keep track of
how many userspace apps are using a particular PF.
- - The modules register their handlers when a userspace app wants to use
a PF. Return -EBUSY when another handler is already registered.
- - When the last userspace app using a particular PF exits, that the
module may unregister its handlers
- - nfqnl_enqueue_packet (and nf_log_packet) must check if the app
asociated with the destination queue has requested this PF if not it
must not queue/log the packet. (*)


A more radical approarch would be to make the modules register themselve
s when they are loaded. But hen we must somehow tell the modules for
which PF they should register themselves. Or should they register
themselves for all PFs??


Comments?

cu
Gregor

(*) This is necessary to avoid that apps get packets from PFs that they
don't want. Image on app registering for PF_INET and one for PF_INET6.
When both apps are running both will see PF_INET and PF_INET6 packets.
When one of the apps exits, the "foreign" packets are no longer
delivered. This ambuguity should be avoided.




- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD/4T8dGiwgbikMYMRAqZgAJ9vo+DJLjq2NOsmogSLkaSF8wMCmgCePPCS
g41l+yC0bz7kkWCxIoonN1E=
=qfU/
-----END PGP SIGNATURE-----
