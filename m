From: "Wei Koong CHAI" <eem1wc@eim.surrey.ac.uk>
Subject: [libipq] Shutdown problem
Date: Wed, 3 Jul 2002 22:54:00 +0100 (BST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1257.131.227.137.112.1025733240.squirrel@ike.ee.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all,

   I have successfully setup my bridge with netfilter capability to 
connect two segment of LANs together and now using the below: -

[1] kernel 2.4.18 (patched with bridge-nf-0.0.6-against-2.4.18.diff)
[2] iptables-1.2.5
[3] bridge-utils-0.9.5

   Then i started to develop a userspace program using libipq. Everything 
works fine until i want to shutdown my linux box. I get the message below 
every time i try to shutdown my system.

unregister_netdevice: waiting for eth1 to become free. Usage count = 14157

   I get the same message (except the number of usage count)... 

   Has anybody ever encounter this problem before? Please advice me on how 
to solve this. I have actually post this problem to the bridge mailing list 
but after several exchange of mails with the bridge maintainer, it seems 
that it's not the bridge problem. Most probably, it is with my userspace 
program. But then, i am writing my program strictly base on the example 
given in the libipq man pages. 

   There is a suggestion that maybe there's packet leaking but i can't 
figure out how could there be any leak.

Thank you in advance.
