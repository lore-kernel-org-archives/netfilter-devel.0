From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: netfilter modul ipt_recent hickup with suspend to ram
Date: Mon, 16 Apr 2007 18:46:03 +0200
Message-ID: <200704161846.05908.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1414093.F6DcZlklGX";
	protocol="application/pgp-signature"; micalg=pgp-sha1
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

--nextPart1414093.F6DcZlklGX
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Mh6IGW60Rnob/Zh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_Mh6IGW60Rnob/Zh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm wondering why after a "suspend to ram" or a "suspend to disk" the amoun=
t of
ip adresses increases drastically w/o removing old addresses.

I'll attach the content of /proc/net/ipt_recent/UDP got at 17:35 (file 1) a=
nd at
18:37 (file 2), I suspended to ram at 17:36 at waked up the system at 17:49=
, after
wakeup I restarted the ppp0 interface and got a new ip address.

My system is a Thinkpad T41 running a stable Gentoo with kernel
2.6.19-gentoo-r5.


=2D-=20
MfG/Sincerely

Toralf F=F6rster

--Boundary-01=_Mh6IGW60Rnob/Zh
Content-Type: text/plain;
  charset="iso-8859-1";
  name="UDP.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="UDP.1"

src=77.128.2.214 ttl: 119 last_seen: 830291 oldest_pkt: 8 4294893265, 4294895267, 287147, 289139, 647869, 649855, 828304, 830291
src=84.163.170.223 ttl: 120 last_seen: 722803 oldest_pkt: 10 4294916510, 4294918536, 129532, 131574, 309931, 311960, 490367, 492377, 720805, 722803
src=84.173.43.126 ttl: 56 last_seen: 694412 oldest_pkt: 6 507935, 509899, 513940, 688395, 690397, 694412
src=204.16.209.141 ttl: 54 last_seen: 4294905219 oldest_pkt: 2 4294905217, 4294905219
src=221.130.192.55 ttl: 52 last_seen: 341443 oldest_pkt: 4 341427, 341435, 341437, 341443
src=124.247.123.116 ttl: 48 last_seen: 377667 oldest_pkt: 1 377667
src=60.12.166.198 ttl: 45 last_seen: 422838 oldest_pkt: 2 422836, 422838
src=90.186.181.231 ttl: 112 last_seen: 661232 oldest_pkt: 6 4294894923, 4294896104, 107269, 109249, 659252, 661232
src=217.233.248.77 ttl: 121 last_seen: 433787 oldest_pkt: 9 4294814741, 4294816751, 4294820801, 237928, 239934, 243932, 427714, 429739, 433787
src=129.147.224.96 ttl: 55 last_seen: 560479 oldest_pkt: 1 560479
src=24.14.106.170 ttl: 108 last_seen: 4294932082 oldest_pkt: 1 4294932082
src=55.203.42.129 ttl: 60 last_seen: 725885 oldest_pkt: 2 725883, 725885
src=58.19.183.42 ttl: 46 last_seen: 610785 oldest_pkt: 1 610785
src=221.208.208.89 ttl: 45 last_seen: 724889 oldest_pkt: 2 723279, 724889
src=24.64.212.252 ttl: 64 last_seen: 151580 oldest_pkt: 3 151578, 151580, 151580
src=88.1.251.154 ttl: 116 last_seen: 206228 oldest_pkt: 2 206224, 206228
src=62.214.212.69 ttl: 120 last_seen: 820003 oldest_pkt: 10 4294863238, 4294865270, 76558, 78586, 457366, 459368, 637583, 639582, 817985, 820003
src=221.208.208.101 ttl: 42 last_seen: 4294889165 oldest_pkt: 1 4294889165
src=84.184.197.110 ttl: 120 last_seen: 825844 oldest_pkt: 9 4312, 6368, 10364, 595581, 597631, 601661, 819831, 821832, 825844
src=201.236.165.79 ttl: 113 last_seen: 4294802527 oldest_pkt: 2 4294802519, 4294802527
src=28.42.173.12 ttl: 59 last_seen: 123923 oldest_pkt: 1 123923
src=60.12.192.35 ttl: 46 last_seen: 626708 oldest_pkt: 2 626696, 626708
src=213.39.139.127 ttl: 63 last_seen: 34787 oldest_pkt: 4 31785, 32807, 33803, 34787

--Boundary-01=_Mh6IGW60Rnob/Zh
Content-Type: text/plain;
  charset="iso-8859-1";
  name="UDP.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="UDP.2"

src=77.128.2.214 ttl: 119 last_seen: 830291 oldest_pkt: 8 4294893265, 4294895267, 287147, 289139, 647869, 649855, 828304, 830291
src=71.109.130.122 ttl: 114 last_seen: 3922981 oldest_pkt: 1 3922981
src=103.166.103.20 ttl: 59 last_seen: 2780964 oldest_pkt: 1 2780964
src=204.16.209.160 ttl: 54 last_seen: 3815599 oldest_pkt: 1 3815599
src=207.253.114.39 ttl: 113 last_seen: 2833120 oldest_pkt: 1 2833120
src=84.163.170.223 ttl: 120 last_seen: 722803 oldest_pkt: 10 4294916510, 4294918536, 129532, 131574, 309931, 311960, 490367, 492377, 720805, 722803
src=60.11.125.55 ttl: 45 last_seen: 2966190 oldest_pkt: 2 2941018, 2966190
src=84.173.43.126 ttl: 56 last_seen: 694412 oldest_pkt: 6 507935, 509899, 513940, 688395, 690397, 694412
src=24.226.198.88 ttl: 117 last_seen: 3472234 oldest_pkt: 1 3472234
src=204.16.209.141 ttl: 54 last_seen: 4294905219 oldest_pkt: 2 4294905217, 4294905219
src=81.198.228.177 ttl: 48 last_seen: 3429317 oldest_pkt: 3 3428331, 3428823, 3429317
src=221.130.192.55 ttl: 52 last_seen: 341443 oldest_pkt: 4 341427, 341435, 341437, 341443
src=124.247.123.116 ttl: 48 last_seen: 377667 oldest_pkt: 1 377667
src=202.97.238.204 ttl: 47 last_seen: 3002133 oldest_pkt: 2 3002133, 3002133
src=60.12.166.198 ttl: 45 last_seen: 422838 oldest_pkt: 2 422836, 422838
src=172.201.79.184 ttl: 114 last_seen: 3973235 oldest_pkt: 2 3973218, 3973235
src=90.186.181.231 ttl: 112 last_seen: 841476 oldest_pkt: 8 4294894923, 4294896104, 107269, 109249, 659252, 661232, 839456, 841476
src=217.233.248.77 ttl: 121 last_seen: 433787 oldest_pkt: 9 4294814741, 4294816751, 4294820801, 237928, 239934, 243932, 427714, 429739, 433787
src=89.196.28.12 ttl: 116 last_seen: 3635806 oldest_pkt: 19 3616380, 3617064, 3617862, 3618872, 3619862, 3621668, 3622588, 3624024, 3625060, 3625811, 3627083, 3628433, 3629049, 3630531, 3632947, 3633081, 3633857, 3634932, 3635806
src=129.147.224.96 ttl: 55 last_seen: 560479 oldest_pkt: 1 560479
src=24.14.106.170 ttl: 108 last_seen: 4294932082 oldest_pkt: 1 4294932082
src=55.203.42.129 ttl: 60 last_seen: 725885 oldest_pkt: 2 725883, 725885
src=57.36.209.198 ttl: 55 last_seen: 2136174 oldest_pkt: 1 2136174
src=58.19.183.42 ttl: 46 last_seen: 610785 oldest_pkt: 1 610785
src=204.16.210.172 ttl: 54 last_seen: 2811018 oldest_pkt: 2 2811018, 2811018
src=204.16.209.120 ttl: 54 last_seen: 4000364 oldest_pkt: 1 4000364
src=114.131.237.102 ttl: 60 last_seen: 2503546 oldest_pkt: 1 2503546
src=217.145.252.43 ttl: 112 last_seen: 2576396 oldest_pkt: 1 2576396
src=154.107.166.26 ttl: 60 last_seen: 3215258 oldest_pkt: 1 3215258
src=218.27.16.156 ttl: 45 last_seen: 2335029 oldest_pkt: 1 2335029
src=221.208.208.89 ttl: 45 last_seen: 724889 oldest_pkt: 2 723279, 724889
src=89.55.165.234 ttl: 119 last_seen: 3039460 oldest_pkt: 1 3039460
src=24.64.212.252 ttl: 64 last_seen: 151580 oldest_pkt: 3 151578, 151580, 151580
src=88.1.251.154 ttl: 116 last_seen: 206228 oldest_pkt: 2 206224, 206228
src=204.16.209.130 ttl: 54 last_seen: 2934323 oldest_pkt: 2 2934321, 2934323
src=62.214.212.69 ttl: 120 last_seen: 820003 oldest_pkt: 10 4294863238, 4294865270, 76558, 78586, 457366, 459368, 637583, 639582, 817985, 820003
src=221.208.208.101 ttl: 42 last_seen: 4294889165 oldest_pkt: 1 4294889165
src=84.58.91.60 ttl: 119 last_seen: 3836586 oldest_pkt: 1 3836586, 3817522, 3818510, 3819744, 3820682, 3821574, 3822504, 3823562, 3824668, 3825518, 3826512, 3827519, 3828521, 3829503, 3830511, 3831677, 3832509, 3833577, 3835097, 3835659
src=84.184.197.110 ttl: 120 last_seen: 825844 oldest_pkt: 9 4312, 6368, 10364, 595581, 597631, 601661, 819831, 821832, 825844
src=193.170.123.171 ttl: 109 last_seen: 2483896 oldest_pkt: 1 2483896
src=221.130.192.123 ttl: 52 last_seen: 2611312 oldest_pkt: 1 2611312
src=202.97.238.205 ttl: 46 last_seen: 2386609 oldest_pkt: 2 2386607, 2386609
src=201.236.165.79 ttl: 113 last_seen: 4294802527 oldest_pkt: 2 4294802519, 4294802527
src=208.255.137.99 ttl: 112 last_seen: 4376813 oldest_pkt: 1 4376813
src=28.42.173.12 ttl: 59 last_seen: 123923 oldest_pkt: 1 123923
src=60.12.192.35 ttl: 46 last_seen: 626708 oldest_pkt: 2 626696, 626708
src=202.97.238.130 ttl: 46 last_seen: 2011038 oldest_pkt: 1 2011038
src=84.39.91.252 ttl: 113 last_seen: 2388065 oldest_pkt: 1 2388065
src=84.179.117.69 ttl: 121 last_seen: 1898113 oldest_pkt: 1 1898113, 1879111, 1880132, 1881112, 1882828, 1883110, 1884112, 1885122, 1886112, 1887112, 1888110, 1889112, 1890113, 1891117, 1892137, 1893155, 1894113, 1895113, 1896113, 1897113
src=114.92.17.109 ttl: 47 last_seen: 2542990 oldest_pkt: 1 2542990
src=212.155.152.87 ttl: 55 last_seen: 2262080 oldest_pkt: 1 2262080
src=213.39.139.127 ttl: 63 last_seen: 34787 oldest_pkt: 4 31785, 32807, 33803, 34787

--Boundary-01=_Mh6IGW60Rnob/Zh--

--nextPart1414093.F6DcZlklGX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGI6hNhyrlCH22naMRAir0AKC1gepW9Q+96bhwv60YRFj9F7oklwCdFPwl
tVpwiNx2nSuXN7Ekj2NGdjg=
=PbsH
-----END PGP SIGNATURE-----

--nextPart1414093.F6DcZlklGX--
