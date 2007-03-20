From: Dan Purcell <dpurcell@nitrosecurity.com>
Subject: NFLOG and ulogd-2: not talking to each other
Date: Tue, 20 Mar 2007 09:57:49 -0600
Message-ID: <4600047D.6030106@nitrosecurity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Has anyone here had any experience with NFLOG and ulogd-2?  Anyone been
successful in putting this together?  I have tried posting to the
gnumonks.org's ulogd mailing list, but it seams to be lifeless.

I successfully built the xt_NFLOG target from the 2.6.20 kernel, and am
using iptables 1.3.7 (which includes the NFLOG target).  I replaced the
libipt_NFLOG.c and libip6t_NFLOG.c files with those that are in
netfilter's SVN, as I understand there is a problem (bug) with the
userspace side regarding nflog-groups.

I set up my ulogd configuration file, added a stack that included the
NFLOG input plugin.  in the parameter section, I set the NFLOG group to
16 (I verified that ulogd says it is attaching to group number 16 by
viewing /var/log/ulogd.log).  I add the following iptables rule:
ip6tables -A FORWARD -j NFLOG --nflog-group 16.  My system is set up
with a bridge, and I can tcpdump the ipv6 traffic going by.

The counters on the ip6tables -nvL FORWARD increases, but I don't think
I am not getting anything to ulogd.  My /var/log/messages fills up with
logs like the following:

 Mar 19 22:55:04 localhost kernel: [3003211.629163] nf_log_packet: can't
 log since no backend logging module loaded in! Please either load one,
 or disable logging explicitly

I have also ran ulogd in gdb, and have put a break point in
ulogd_inppkt_NFLOG.c's interp_packet(..) function, but the break point
is never reached.

How can I verify that ulogd from the user-side is  "connected" to the
kernel side?  What am I missing?

In case it helps, I will paste my ulogd.conf here:

- ---------------------------------

[global]
logfile="/var/log/ulogd.log"
loglevel=1
rmem=131071
bufsize=150000

plugin="/root/work/lib/ulogd/ulogd_inppkt_NFLOG.so"
plugin="/root/work/lib/ulogd/ulogd_output_OPRINT.so"

stack=log1:NFLOG,op1:OPRINT

[log1]
# netlink multicast group (the same as the iptables --ulog-nlgroup param)
group=16

[op1]
file="/var/log/ulogd_oprint.log"
sync=1
- --

- --------------------------------------------------------------
Dan Purcell, Software Engineer     dpurcell@nitrosecurity.com
NitroSecurity, Inc.                            (208) 552-5332
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGAAR9Tqu8TzII/vURAq2YAJkBxSckPsCKHlee0tA5TNJJ5hnOOgCeJpMY
ZgP3QkmLWYYro9M468b81+k=
=Afu2
-----END PGP SIGNATURE-----
