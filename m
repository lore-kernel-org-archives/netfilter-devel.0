From: canqun zhang <canqunzhang@gmail.com>
Subject: kernel panic when running /etc/init.d/iptables restart
Date: Mon, 24 Dec 2012 13:51:41 +0800
Message-ID: <CAFFEFTXxsPRf1Rmxyih0wL4O6q8G0OFmz0iRLX0tOYedYfajHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:35954 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2LXFvm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Dec 2012 00:51:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick=A3=AC
If i start  one lxc container instance, and then in the system there
will be two net namespaces,one is init_net namespace, the other is
created by lxc.If running "/etc/init.d/iptables restart",the system
will be panic. I find iptables restarting will clean init_net
namespace firstly,then clean the net namespace created by lxc,buf
related functions about cleaning up init_net namespace will destroy
global variables such as nf_ct_destroy,ip_ct_attach=A3=ACetc.So,funtion=
s
cleaning up  the other net namespace will be panic.

I fixed it up (see below) .If the system need cleaning init_net
namespace, Ip conntrack belonging to other namespaces will be cleaned
up firstly.

diff -r 7884e663ef6f -r 57fd45b8a144 net/netfilter/nf_conntrack_
core.c
--- a/net/netfilter/nf_conntrack_core.c Sun Dec 09 21:41:08 2012 +0800
+++ b/net/netfilter/nf_conntrack_core.c Sun Dec 23 16:28:15 2012 +0800
@@ -1122,7 +1122,22 @@
diff -r 7884e663ef6f -r 57fd45b8a144 net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c Sun Dec 09 21:41:08 2012 +0800
+++ b/net/netfilter/nf_conntrack_core.c Sun Dec 23 16:28:15 2012 +0800
@@ -1122,7 +1122,22 @@

 static void nf_conntrack_cleanup_net(struct net *net)
 {
- i_see_dead_people:
+       if (net =3D=3D &init_net) {
+               struct net *net_poll;
+               rcu_read_lock();
+               for_each_net_rcu(net_poll) {
+                       synchronize_net();
+               again:
+                       nf_ct_iterate_cleanup(net_poll, kill_all, NULL)=
;
+                       nf_ct_release_dying_list(net_poll);
+                       if (atomic_read(&net_poll->ct.count) !=3D 0) {
+                               schedule();
+                               goto again;
+                       }
+               }
+               rcu_read_unlock();
+       }
+i_see_dead_people:
        nf_ct_iterate_cleanup(net, kill_all, NULL);
        nf_ct_release_dying_list(net);
        if (atomic_read(&net->ct.count) !=3D 0) {
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
