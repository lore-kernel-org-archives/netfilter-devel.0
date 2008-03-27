From: Whit Blauvelt <whit@transpect.com>
Subject: Re: Why does ipv6 enabled interfere with ipv4 SNAT?
Date: Thu, 27 Mar 2008 10:10:26 -0400
Message-ID: <20080327141026.GA3288@transpect.com>
References: <20080325012807.GA15637@transpect.com> <alpine.LNX.1.10.0803250254100.9368@fbirervta.pbzchgretzou.qr> <20080325024424.GA16089@transpect.com> <Pine.LNX.4.64.0803251156560.1535@blackhole.kfki.hu> <20080325142553.GA8783@transpect.com> <47E91FEF.9080705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E91FEF.9080705@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Mar 25, 2008 at 04:53:19PM +0100, Patrick McHardy wrote:

> Please post the list of modules loaded and the output of
> /proc/net/nf_conntrack.

First here is the list by the system in question, working once the ipv6
module is blocked from loading at boot. Next is the list from a system with
identical hardware and near-identical configuration (same firewall rules),
but with ipv6 loading - and which also has only 4 of the 6 NICs showing up
in the ipv6 proc conf space, and also has NAT (in this case DNAT is what I
tested) failing - also where the NICs on the Internet side of things are
those coincidentally not showing up with proc ipv6 conf settings. 

As to the output of /proc/net/nf_conntrack, you just want to see anything,
or under specific load? I'm not going to just publicly post the raw data -
although both systems have some there - since IPs can identify my client and
their clients, which would violate confidentiality.

Okay, the fixed system:

Module                  Size  Used by
drbd                  208136  2 
cn                      9632  1 drbd
parport_pc             37668  0 
lp                     12452  0 
parport                37448  2 parport_pc,lp
loop                   19076  0 
sg                     36380  0 
sr_mod                 17700  0 
cdrom                  37408  1 sr_mod
ata_generic             8580  0 
usbhid                 29664  0 
hid                    28928  1 usbhid
pcspkr                  4224  0 
psmouse                39952  0 
serio_raw               8068  0 
shpchp                 34580  0 
pci_hotplug            32576  1 shpchp
evdev                  11136  0 
ipt_TOS                 3200  16 
ipt_REJECT              5760  2 
xt_state                3456  372 
nf_nat_ftp              4352  0 
nf_conntrack_ftp       11136  1 nf_nat_ftp
xt_limit                3584  3 
xt_tcpudp               4224  616 
ipt_LOG                 7552  2 
iptable_mangle          3840  1 
iptable_nat             8708  1 
nf_nat                 20012  2 nf_nat_ftp,iptable_nat
nf_conntrack_ipv4      19724  374 iptable_nat
nf_conntrack           65160  6 xt_state,nf_nat_ftp,nf_conntrack_ftp,iptable_nat,nf_nat,nf_conntrack_ipv4
nfnetlink               6936  3 nf_nat,nf_conntrack_ipv4,nf_conntrack
iptable_filter          3968  1 
ip_tables              13924  3 iptable_mangle,iptable_nat,iptable_filter
x_tables               16260  8 ipt_TOS,ipt_REJECT,xt_state,xt_limit,xt_tcpudp,ipt_LOG,iptable_nat,ip_tables
ext3                  133640  4 
jbd                    60456  1 ext3
mbcache                 9732  1 ext3
ata_piix               17540  0 
libata                125296  2 ata_generic,ata_piix
ehci_hcd               36748  0 
bnx2                  157208  0 
e1000                 126656  0 
uhci_hcd               26640  0 
usbcore               138760  4 usbhid,ehci_hcd,uhci_hcd
cciss                  61700  7 
scsi_mod              146828  4 sg,sr_mod,libata,cciss
dm_mirror              24320  0 
dm_snapshot            18980  0 
dm_mod                 58816  10 dm_mirror,dm_snapshot
thermal                14344  0 
processor              32072  1 thermal
fan                     5764  0 
fuse                   47124  1 
apparmor               40600  0 
commoncap               8320  1 apparmor

Here's the list from a nearly identical sytem that's still got the ipv6
module loading, and that's also failing at both populating the proc ipv6
space fully (same thing - just four of the 6 NICs) and also failing at NAT
(in this case DNAT was what I tried):

Module                  Size  Used by
ipt_TOS                 3200  16 
ipt_REJECT              5760  2 
nf_nat_ftp              4352  0 
nf_conntrack_ftp       11136  1 nf_nat_ftp
xt_limit                3584  3 
xt_state                3456  92 
xt_tcpudp               4224  266 
ipt_LOG                 7552  2 
iptable_mangle          3840  1 
iptable_nat             8708  1 
nf_nat                 20012  2 nf_nat_ftp,iptable_nat
nf_conntrack_ipv4      19724  94 iptable_nat
nf_conntrack           65160  6 nf_nat_ftp,nf_conntrack_ftp,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4
nfnetlink               6936  3 nf_nat,nf_conntrack_ipv4,nf_conntrack
iptable_filter          3968  1 
ip_tables              13924  3 iptable_mangle,iptable_nat,iptable_filter
x_tables               16260  8 ipt_TOS,ipt_REJECT,xt_limit,xt_state,xt_tcpudp,ipt_LOG,iptable_nat,ip_tables
drbd                  208136  1 
cn                      9632  1 drbd
ipv6                  278916  30 
parport_pc             37668  0 
af_packet              24840  2 
lp                     12452  0 
parport                37448  2 parport_pc,lp
loop                   19076  0 
serio_raw               8068  0 
pcspkr                  4224  0 
psmouse                39952  0 
shpchp                 34580  0 
pci_hotplug            32576  1 shpchp
evdev                  11136  0 
sg                     36380  0 
sr_mod                 17700  0 
cdrom                  37408  1 sr_mod
usbhid                 29664  0 
hid                    28928  1 usbhid
ata_piix               17540  0 
ext3                  133640  2 
jbd                    60456  1 ext3
mbcache                 9732  1 ext3
ehci_hcd               36748  0 
ata_generic             8580  0 
libata                125296  2 ata_piix,ata_generic
uhci_hcd               26640  0 
usbcore               138760  4 usbhid,ehci_hcd,uhci_hcd
e1000                 126656  0 
bnx2                  157208  0 
cciss                  61700  6 
scsi_mod              146828  4 sg,sr_mod,libata,cciss
dm_mirror              24320  0 
dm_snapshot            18980  0 
dm_mod                 58816  10 dm_mirror,dm_snapshot
thermal                14344  0 
processor              32072  1 thermal
fan                     5764  0 
fuse                   47124  1 
apparmor               40600  0 
commoncap               8320  1 apparmor

- Whit
