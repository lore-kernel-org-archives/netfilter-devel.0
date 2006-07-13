From: Felipe Kellermann <stdfk@terra.com.br>
Subject: [PATCH] libnfnetlink 0.0.16 and missing types
Date: Thu, 13 Jul 2006 18:42:14 -0300 (BRT)
Message-ID: <Pine.LNX.4.64.0607131821350.3308@pvaqre.alien.bet>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1524943022-1152826934=:3308"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1524943022-1152826934=:3308
Content-Type: TEXT/PLAIN; charset=US-ASCII

Using 2.6.17.1, GCC 4.1.1. libnfnetlink isn't compiling correctly.

libnfnetlink.c includes linux/netlink.h, which uses undefined typedefs 
because neither libnfnetlink.c nor linux/netlink.h includes linux/types.h.

Am just wondering if there is a rationale about the correct place to put 
this type of include (types.h). IMHO it would have to be placed in every 
type of header which uses types defined in linux/types.h. The include safe 
guards would do the job about the multiple inclusions.

So the simpler (and not exactly correct IMHO) fix is attached (used in the 
Fedora Core package now). The more general and correct fix would be to add 
includes in the headers using the types and not including it.

For instance, to investigate the number of users of __u32 which does not 
include -- at least directly -- linux/types.h, I did this searching:

[felipek@cinder]/usr/include/linux% for h in $(grep __u32 -Flr *.h); do grep -Fq "linux/types.h" $h || echo $h; done
adfs_fs_sb.h
atmbr2684.h
atm_idt77105.h
bfs_fs.h
capi.h
cdrom.h
errqueue.h
fb.h
filter.h
ftape-header-segment.h
icmp.h
icmpv6.h
if_fddi.h
if_hippi.h
if_ppp.h
if_shaper.h
if_tunnel.h
igmp.h
input.h
intermezzo_fs.h
ipv6.h
ipv6_route.h
ipx.h
irda.h
ite_gpio.h
jbd.h
jffs.h
joystick.h
matroxfb.h
minix_fs.h
mroute.h
msdos_fs.h
netlink.h
nfs_fs_i.h
nfs_xdr.h
nubus.h
pkt_cls.h
pkt_sched.h
pmu.h
pnp_resource.h
ppp_defs.h
qnx4_fs.h
qnx4_fs_i.h
qnxtypes.h
random.h
reiserfs_fs_i.h
reiserfs_fs_sb.h
romfs_fs.h
rtnetlink.h
synclink.h
ufs_fs_i.h
video_decoder.h
videodev2.h
video_encoder.h
watchdog.h
zorro.h

-- 
Felipe Kellermann
--8323328-1524943022-1152826934=:3308
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-linux-types.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0607131842140.3308@pvaqre.alien.bet>
Content-Description: 
Content-Disposition: attachment; filename=0001-linux-types.patch

ZGlmZiAtdXJOIGxpYm5mbmV0bGluay0wLjAuMTYub3JpZy9zcmMvbGlibmZu
ZXRsaW5rLmMgbGlibmZuZXRsaW5rLTAuMC4xNi9zcmMvbGlibmZuZXRsaW5r
LmMNCi0tLSBsaWJuZm5ldGxpbmstMC4wLjE2Lm9yaWcvc3JjL2xpYm5mbmV0
bGluay5jCTIwMDYtMDUtMTcgMTg6MjA6MzEuMDAwMDAwMDAwICswNDAwDQor
KysgbGlibmZuZXRsaW5rLTAuMC4xNi9zcmMvbGlibmZuZXRsaW5rLmMJMjAw
Ni0wNy0xNCAwMDo0OTowNy4wMDAwMDAwMDAgKzA0MDANCkBAIC0zNyw2ICsz
Nyw3IEBADQogI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KICNpbmNsdWRlIDxz
eXMvc29ja2V0Lmg+DQogDQorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQog
I2luY2x1ZGUgPGxpbnV4L25ldGxpbmsuaD4NCiANCiAjaW5jbHVkZSA8bGli
bmZuZXRsaW5rL2xpYm5mbmV0bGluay5oPg0K

--8323328-1524943022-1152826934=:3308--
