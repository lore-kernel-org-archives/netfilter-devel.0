From: "Wei Koong CHAI" <eem1wc@eim.surrey.ac.uk>
Subject: Re: [libipq] Shutdown problem
Date: Thu, 4 Jul 2002 11:52:45 +0100 (BST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1105.131.227.136.16.1025779965.squirrel@ike.ee.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <jmorris@intercode.com.au>, <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again... 

   Here's more information on my system. I'm really new to Linux 
networking, so i'm not really sure what kind of information that is useful 
or useless for you to solve this problem. Forgive me if information i give 
here are useless...

Topology
--------

                             bridge (br01)
+--------------+          +---------------+             +--------------+
| 192.168.1.12 |----(eth1)| 192.168.1.100 |(eth0)-------| 192.168.1.30 |
+--------------+          +---------------+             +--------------+

   I am only bridging 2 workstation as this is only an University student 
experimental project. 

Bridge (br01) Info 
------------------
Kernel    : 2.4.18 (with netfilter (firewalling) support for bridge enabled)
Patch     : bridge-nf-0.0.6-against-2.4.18.diff
Netfilter : iptables-1.2.5.tar.bz2 
            (Everything related to netfilter is compiled into the kernel)
Bridge    : bridge-utils-0.9.5.tar 

Bridge Config
-------------
% brctl addbr br01
% brctl addif br01 eth0
% brctl addif br01 eth1
% ifconfig eth0 0.0.0.0
% ifconfig eth1 0.0.0.0
% ifconfig br01 192.168.1.100 netmask 255.255.255.0 up

Iptables
--------
% iptables -A FORWARD -s 192.168.1.12 -j QUEUE
% iptables -A FORWARD -s 192.168.1.30 -j QUEUE

Reboot Messages:
----------------

I straightaway get the error message when I try to reboot:

Unregister-netdevice: waiting for eth1 to become free. Usage count = ????

Shutdown Messages:
------------------

Here’s what I think it’s related to my problem when I try to shutdown:

br01: port 2(eth1) entering disabled state
cardmgr[818]: shutting down socket 1
br01: port 2(eth1) entering disabled state
unregister-netdevice: waiting for eth1 to become free. Usage count = ????

(sometimes, i also receive messages such as below)
shutting down interface eth0: eth0: promiscuous mode enabled.
shutting down interface eth1: br01: promiscuous mode enabled.
br01: port 2(eth1) entering disabled state
device eth1 left promiscuous mode
unregister-netdevice: waiting for eth1 to become free. Usage count = ????

(actually, i don't know where can i get the shutdown log... any pointer on 
this?)

Here's my boot.log
------------------
Jul  4 17:17:59 Home syslog: syslogd startup succeeded
Jul  4 17:17:59 Home syslog: klogd startup succeeded
Jul  4 17:18:00 Home portmap: portmap startup succeeded
Jul  4 17:18:00 Home nfslock: rpc.statd startup succeeded
Jul  4 17:18:00 Home keytable: Loading keymap:  succeeded
Jul  4 17:18:00 Home keytable: Loading system font:  succeeded
Jul  4 17:18:01 Home random: Initializing random number generator:  
succeeded
Jul  4 17:18:01 Home netfs: Mounting other filesystems:  succeeded
Jul  4 17:18:02 Home autofs: automount startup succeeded
Jul  4 17:17:42 Home rc.sysinit: Mounting proc filesystem:  succeeded 
Jul  4 17:17:42 Home sysctl: net.ipv4.ip_forward = 0 
Jul  4 17:17:42 Home sysctl: net.ipv4.conf.default.rp_filter = 1 
Jul  4 17:17:42 Home rc.sysinit: Configuring kernel parameters:  succeeded 
Jul  4 17:17:42 Home date: Thu Jul  4 17:15:33 BST 2002 
Jul  4 17:17:42 Home rc.sysinit: Setting clock  (localtime): Thu Jul  4 
17:15:33 BST 2002 succeeded 
Jul  4 17:17:42 Home rc.sysinit: Loading default keymap succeeded 
Jul  4 17:17:42 Home rc.sysinit: Setting default font (lat0-sun16):  
succeeded 
Jul  4 17:17:42 Home rc.sysinit: Activating swap partitions:  succeeded 
Jul  4 17:17:42 Home rc.sysinit: Setting hostname Home:  succeeded 
Jul  4 17:17:42 Home fsck: / was not cleanly unmounted, check forced. 
Jul  4 17:17:42 Home fsck: Deleted inode 257168 has zero dtime.  FIXED. 
Jul  4 17:17:42 Home fsck: /:  
Jul  4 17:18:02 Home pcmcia: Starting PCMCIA services:
Jul  4 17:17:42 Home fsck: Deleted inode 259968 has zero dtime.  FIXED. 
Jul  4 17:17:42 Home fsck: /: 129316/448000 files (0.6% non-contiguous), 
607658/895623 blocks 
Jul  4 17:17:42 Home rc.sysinit: Checking root filesystem succeeded 
Jul  4 17:17:42 Home rc.sysinit: Remounting root filesystem in read-write 
mode:  succeeded 
Jul  4 17:17:42 Home rc.sysinit: Finding module dependencies:  succeeded 
Jul  4 17:17:43 Home rc.sysinit: Checking filesystems succeeded 
Jul  4 17:17:43 Home rc.sysinit: Mounting local filesystems:  succeeded 
Jul  4 17:17:43 Home rc.sysinit: Enabling local filesystem quotas:  
succeeded 
Jul  4 17:17:43 Home rc.sysinit: Enabling swap space:  succeeded 
Jul  4 17:17:48 Home kudzu: Updating /etc/fstab succeeded 
Jul  4 17:17:56 Home kudzu:  succeeded 
Jul  4 17:17:56 Home sysctl: net.ipv4.ip_forward = 0 
Jul  4 17:17:56 Home sysctl: net.ipv4.conf.default.rp_filter = 1 
Jul  4 17:17:56 Home network: Setting network parameters:  succeeded 
Jul  4 17:17:57 Home network: Bringing up interface lo:  succeeded 
Jul  4 17:17:59 Home network: Bringing up interface eth0:  succeeded 
Jul  4 17:18:02 Home pcmcia:  cardmgr.
Jul  4 17:18:03 Home rc: Starting pcmcia:  succeeded
Jul  4 17:18:06 Home xinetd: xinetd startup succeeded
Jul  4 17:18:08 Home sendmail: sendmail startup succeeded
Jul  4 17:18:08 Home gpm: gpm startup succeeded
Jul  4 17:18:09 Home crond: crond startup succeeded
Jul  4 17:18:10 Home xfs: xfs startup succeeded
Jul  4 17:18:10 Home anacron: anacron startup succeeded
Jul  4 17:18:10 Home atd: atd startup succeeded
Jul  4 17:18:12 Home netconf:   Checking kernel configuration
Jul  4 17:18:12 Home linuxconf: Running Linuxconf hooks:  succeeded
Jul  4 17:18:12 Home 
wine: /etc/rc5.d/S99wine: /proc/sys/fs/binfmt_misc/register: No such file 
or directory
Jul  4 17:18:12 Home 
wine: /etc/rc5.d/S99wine: /proc/sys/fs/binfmt_misc/register: No such file 
or directory
Jul  4 17:18:12 Home rc: Starting wine:  failed


Note:
-----

I need to state that, without using netfilter support i.e. only working 
with the bridge (brctl), i didn't receive such message when i shutdown my 
bridge. That is why i thought maybe my libipq program is leaking packets... 
but i'm really no expert in these things.

Thank you.
