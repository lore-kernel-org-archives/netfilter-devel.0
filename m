From: netfilter@interlinx.bc.ca
Subject: Specific problem and evidence of tcp-window-tracking error
Date: Mon, 11 Nov 2002 13:00:08 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021111180008.GN8377@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E+IgQzR66AIOcbjA"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--E+IgQzR66AIOcbjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

OK.  I have pulled one incident of tcp-window-tracking errors and the
evidence that goes along with it.  I have the full (binary) tcpdump
file if you want to look further into this.

Nov 11 05:05:17 gw.ilinx kernel: SRC=3D64.37.218.202 DST=3D205.210.52.190 L=
EN=3D1420 TOS=3D0x00 PREC=3D0x00 TTL=3D113 ID=3D15749 DF PROTO=3DTCP SPT=3D=
80 DPT=3D2562 SEQ=3D1504198127 ACK=3D943437539 WINDOW=3D16560 RES=3D0x00 AC=
K URGP=3D0 OPT (0101080A005256410BB486CC) ip_conntrack_tcp: INVALID: Out of=
 window data; SEQ is under the lower bound (retransmitted already ACKed dat=
a)=20

Here is the relevant tcpdump for this error with my summary of what
happened below it:

05:05:17.011135 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504187183 win 62928 <nop,nop,timestamp 196380309 5396=
025> (DF) (ttl 63, id 13832, len 52)
05:05:17.021087 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504187183:1504188551(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15619, len 1420)
05:05:17.021909 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504188551 win 62928 <nop,nop,timestamp 196380310 5396=
025> (DF) (ttl 63, id 13833, len 52)
05:05:17.032219 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504188551:1504189919(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15620, len 1420)
05:05:17.033098 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504189919 win 62928 <nop,nop,timestamp 196380311 5396=
025> (DF) (ttl 63, id 13834, len 52)
05:05:17.044083 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504189919:1504191287(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15621, len 1420)
05:05:17.044942 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504191287 win 62928 <nop,nop,timestamp 196380312 5396=
025> (DF) (ttl 63, id 13835, len 52)
05:05:17.054345 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504191287:1504192655(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15622, len 1420)
05:05:17.055134 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504192655 win 62928 <nop,nop,timestamp 196380313 5396=
025> (DF) (ttl 63, id 13836, len 52)
05:05:17.065715 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504192655:1504194023(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15623, len 1420)
05:05:17.076804 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504194023:1504195391(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15624, len 1420)
05:05:17.077637 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504195391 win 62928 <nop,nop,timestamp 196380316 5396=
025> (DF) (ttl 63, id 13837, len 52)
05:05:17.087657 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504195391:1504196759(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15625, len 1420)
05:05:17.098927 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504196759:1504198127(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380149> (DF) (ttl 113, id 15626, len 1420)
05:05:17.099749 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380318 5396=
025> (DF) (ttl 63, id 13838, len 52)
05:05:17.109846 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: P [tcp sum ok] 1504199495:1504200863(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380293> (DF) (ttl 113, id 15638, len 1420)
05:05:17.110703 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380319 5396=
025,nop,nop,sack sack 1 {1504199495:1504200863} > (DF) (ttl 63, id 13839, l=
en 64)
05:05:17.121107 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504200863:1504202231(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380294> (DF) (ttl 113, id 15639, len 1420)
05:05:17.121946 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380320 5396=
025,nop,nop,sack sack 1 {1504199495:1504202231} > (DF) (ttl 63, id 13840, l=
en 64)
05:05:17.132233 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504202231:1504203599(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380294> (DF) (ttl 113, id 15640, len 1420)
05:05:17.133123 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380321 5396=
025,nop,nop,sack sack 1 {1504199495:1504203599} > (DF) (ttl 63, id 13841, l=
en 64)
05:05:17.144034 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504203599:1504204967(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380296> (DF) (ttl 113, id 15641, len 1420)
05:05:17.144876 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380322 5396=
025,nop,nop,sack sack 1 {1504199495:1504204967} > (DF) (ttl 63, id 13842, l=
en 64)
05:05:17.154371 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504204967:1504206335(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380296> (DF) (ttl 113, id 15642, len 1420)
05:05:17.155209 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380323 5396=
025,nop,nop,sack sack 1 {1504199495:1504206335} > (DF) (ttl 63, id 13843, l=
en 64)
05:05:17.165524 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504206335:1504207703(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380297> (DF) (ttl 113, id 15648, len 1420)
05:05:17.166412 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380324 5396=
025,nop,nop,sack sack 1 {1504199495:1504207703} > (DF) (ttl 63, id 13844, l=
en 64)
05:05:17.176581 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504207703:1504209071(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380297> (DF) (ttl 113, id 15649, len 1420)
05:05:17.177394 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380326 5396=
025,nop,nop,sack sack 1 {1504199495:1504209071} > (DF) (ttl 63, id 13845, l=
en 64)
05:05:17.187669 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504209071:1504210439(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380298> (DF) (ttl 113, id 15652, len 1420)
05:05:17.188490 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380327 5396=
025,nop,nop,sack sack 1 {1504199495:1504210439} > (DF) (ttl 63, id 13846, l=
en 64)
05:05:17.198749 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504210439:1504211807(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380298> (DF) (ttl 113, id 15653, len 1420)
05:05:17.199561 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380328 5396=
025,nop,nop,sack sack 1 {1504199495:1504211807} > (DF) (ttl 63, id 13847, l=
en 64)
05:05:17.209845 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504211807:1504213175(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380299> (DF) (ttl 113, id 15655, len 1420)
05:05:17.210711 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380329 5396=
025,nop,nop,sack sack 1 {1504199495:1504213175} > (DF) (ttl 63, id 13848, l=
en 64)
05:05:17.220922 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504213175:1504214543(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396025 196380299> (DF) (ttl 113, id 15656, len 1420)
05:05:17.221769 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380330 5396=
025,nop,nop,sack sack 1 {1504199495:1504214543} > (DF) (ttl 63, id 13849, l=
en 64)
05:05:17.232271 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504214543:1504215911(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380300> (DF) (ttl 113, id 15662, len 1420)
05:05:17.233155 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380331 5396=
025,nop,nop,sack sack 1 {1504199495:1504215911} > (DF) (ttl 63, id 13850, l=
en 64)
05:05:17.244007 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504215911:1504217279(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380300> (DF) (ttl 113, id 15663, len 1420)
05:05:17.244852 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380332 5396=
025,nop,nop,sack sack 1 {1504199495:1504217279} > (DF) (ttl 63, id 13851, l=
en 64)
05:05:17.254177 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504217279:1504218647(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380301> (DF) (ttl 113, id 15664, len 1420)
05:05:17.255027 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380333 5396=
025,nop,nop,sack sack 1 {1504199495:1504218647} > (DF) (ttl 63, id 13852, l=
en 64)
05:05:17.265536 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504218647:1504220015(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380301> (DF) (ttl 113, id 15665, len 1420)
05:05:17.266360 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380334 5396=
025,nop,nop,sack sack 1 {1504199495:1504220015} > (DF) (ttl 63, id 13853, l=
en 64)
05:05:17.276353 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504220015:1504221383(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380302> (DF) (ttl 113, id 15666, len 1420)
05:05:17.277206 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380335 5396=
025,nop,nop,sack sack 1 {1504199495:1504221383} > (DF) (ttl 63, id 13854, l=
en 64)
05:05:17.287706 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504221383:1504222751(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380302> (DF) (ttl 113, id 15667, len 1420)
05:05:17.288532 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380337 5396=
025,nop,nop,sack sack 1 {1504199495:1504222751} > (DF) (ttl 63, id 13855, l=
en 64)
05:05:17.298746 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504222751:1504224119(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380303> (DF) (ttl 113, id 15668, len 1420)
05:05:17.299589 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380338 5396=
025,nop,nop,sack sack 1 {1504199495:1504224119} > (DF) (ttl 63, id 13856, l=
en 64)
05:05:17.309661 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504224119:1504225487(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380303> (DF) (ttl 113, id 15669, len 1420)
05:05:17.310500 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380339 5396=
025,nop,nop,sack sack 1 {1504199495:1504225487} > (DF) (ttl 63, id 13857, l=
en 64)
05:05:17.320922 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504225487:1504226855(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380304> (DF) (ttl 113, id 15671, len 1420)
05:05:17.321766 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380340 5396=
025,nop,nop,sack sack 1 {1504199495:1504226855} > (DF) (ttl 63, id 13858, l=
en 64)
05:05:17.332054 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504226855:1504228223(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380304> (DF) (ttl 113, id 15672, len 1420)
05:05:17.332940 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380341 5396=
025,nop,nop,sack sack 1 {1504199495:1504228223} > (DF) (ttl 63, id 13859, l=
en 64)
05:05:17.344011 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504228223:1504229591(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380306> (DF) (ttl 113, id 15673, len 1420)
05:05:17.344876 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380342 5396=
025,nop,nop,sack sack 1 {1504199495:1504229591} > (DF) (ttl 63, id 13860, l=
en 64)
05:05:17.354188 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504229591:1504230959(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380306> (DF) (ttl 113, id 15674, len 1420)
05:05:17.355026 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380343 5396=
025,nop,nop,sack sack 1 {1504199495:1504230959} > (DF) (ttl 63, id 13861, l=
en 64)
05:05:17.365335 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504230959:1504232327(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380307> (DF) (ttl 113, id 15675, len 1420)
05:05:17.366181 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380344 5396=
025,nop,nop,sack sack 1 {1504199495:1504232327} > (DF) (ttl 63, id 13862, l=
en 64)
05:05:17.376363 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: P [tcp sum ok] 1504232327:1504233695(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380307> (DF) (ttl 113, id 15676, len 1420)
05:05:17.377205 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380345 5396=
025,nop,nop,sack sack 1 {1504199495:1504233695} > (DF) (ttl 63, id 13863, l=
en 64)
05:05:17.387495 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504233695:1504235063(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380308> (DF) (ttl 113, id 15677, len 1420)
05:05:17.388378 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380347 5396=
025,nop,nop,sack sack 1 {1504199495:1504235063} > (DF) (ttl 63, id 13864, l=
en 64)
05:05:17.398548 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504235063:1504236431(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380308> (DF) (ttl 113, id 15678, len 1420)
05:05:17.399406 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380348 5396=
025,nop,nop,sack sack 1 {1504199495:1504236431} > (DF) (ttl 63, id 13865, l=
en 64)
05:05:17.409664 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504236431:1504237799(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380309> (DF) (ttl 113, id 15679, len 1420)
05:05:17.410514 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380349 5396=
025,nop,nop,sack sack 1 {1504199495:1504237799} > (DF) (ttl 63, id 13866, l=
en 64)
05:05:17.420944 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504237799:1504239167(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380309> (DF) (ttl 113, id 15680, len 1420)
05:05:17.421774 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380350 5396=
025,nop,nop,sack sack 1 {1504199495:1504239167} > (DF) (ttl 63, id 13867, l=
en 64)
05:05:17.431823 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504239167:1504240535(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380310> (DF) (ttl 113, id 15681, len 1420)
05:05:17.432668 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380351 5396=
025,nop,nop,sack sack 1 {1504199495:1504240535} > (DF) (ttl 63, id 13868, l=
en 64)
05:05:17.443948 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504240535:1504241903(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396026 196380310> (DF) (ttl 113, id 15682, len 1420)
05:05:17.444792 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380352 5396=
025,nop,nop,sack sack 1 {1504199495:1504241903} > (DF) (ttl 63, id 13869, l=
en 64)
05:05:17.454229 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504241903:1504243271(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380311> (DF) (ttl 113, id 15684, len 1420)
05:05:17.455089 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380353 5396=
025,nop,nop,sack sack 1 {1504199495:1504243271} > (DF) (ttl 63, id 13870, l=
en 64)
05:05:17.465103 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504243271:1504244639(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380311> (DF) (ttl 113, id 15685, len 1420)
05:05:17.465923 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380354 5396=
025,nop,nop,sack sack 1 {1504199495:1504244639} > (DF) (ttl 63, id 13871, l=
en 64)
05:05:17.476375 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504244639:1504246007(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380312> (DF) (ttl 113, id 15686, len 1420)
05:05:17.477219 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380355 5396=
025,nop,nop,sack sack 1 {1504199495:1504246007} > (DF) (ttl 63, id 13872, l=
en 64)
05:05:17.487538 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504246007:1504247375(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380312> (DF) (ttl 113, id 15687, len 1420)
05:05:17.488377 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380357 5396=
025,nop,nop,sack sack 1 {1504199495:1504247375} > (DF) (ttl 63, id 13873, l=
en 64)
05:05:17.498319 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504247375:1504248743(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380313> (DF) (ttl 113, id 15688, len 1420)
05:05:17.499176 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380358 5396=
025,nop,nop,sack sack 1 {1504199495:1504248743} > (DF) (ttl 63, id 13874, l=
en 64)
05:05:17.509687 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504248743:1504250111(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380313> (DF) (ttl 113, id 15689, len 1420)
05:05:17.510524 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380359 5396=
025,nop,nop,sack sack 1 {1504199495:1504250111} > (DF) (ttl 63, id 13875, l=
en 64)
05:05:17.520754 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504250111:1504251479(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380316> (DF) (ttl 113, id 15690, len 1420)
05:05:17.521612 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380360 5396=
025,nop,nop,sack sack 1 {1504199495:1504251479} > (DF) (ttl 63, id 13876, l=
en 64)
05:05:17.531867 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504251479:1504252847(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380316> (DF) (ttl 113, id 15691, len 1420)
05:05:17.532701 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380361 5396=
025,nop,nop,sack sack 1 {1504199495:1504252847} > (DF) (ttl 63, id 13877, l=
en 64)
05:05:17.543952 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504252847:1504254215(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380316> (DF) (ttl 113, id 15692, len 1420)
05:05:17.544849 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380362 5396=
025,nop,nop,sack sack 1 {1504199495:1504254215} > (DF) (ttl 63, id 13878, l=
en 64)
05:05:17.554000 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504254215:1504255583(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380318> (DF) (ttl 113, id 15693, len 1420)
05:05:17.554845 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380363 5396=
025,nop,nop,sack sack 1 {1504199495:1504255583} > (DF) (ttl 63, id 13879, l=
en 64)
05:05:17.565118 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504255583:1504256951(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380318> (DF) (ttl 113, id 15694, len 1420)
05:05:17.565979 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380364 5396=
025,nop,nop,sack sack 1 {1504199495:1504256951} > (DF) (ttl 63, id 13880, l=
en 64)
05:05:17.576193 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504256951:1504258319(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380318> (DF) (ttl 113, id 15695, len 1420)
05:05:17.577040 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380365 5396=
025,nop,nop,sack sack 1 {1504199495:1504258319} > (DF) (ttl 63, id 13881, l=
en 64)
05:05:17.587576 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504258319:1504259687(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380319> (DF) (ttl 113, id 15696, len 1420)
05:05:17.588423 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380367 5396=
025,nop,nop,sack sack 1 {1504199495:1504259687} > (DF) (ttl 63, id 13882, l=
en 64)
05:05:17.589033 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504199495:1504199507(12) ack 943437539 win 16560 <nop,nop=
,timestamp 5396027 196380320> (DF) (ttl 113, id 15699, len 64)
05:05:17.589623 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504198127 win 62928 <nop,nop,timestamp 196380367 5396=
025,nop,nop,sack sack 2 {1504199495:1504199507}{1504199495:1504259687} > (D=
F) (ttl 63, id 13883, len 72)
05:05:17.599357 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504198127:1504199495(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380320> (DF) (ttl 113, id 15698, len 1420)
05:05:17.610704 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504259687:1504261055(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396027 196380321> (DF) (ttl 113, id 15700, len 1420)
05:05:17.621775 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504261055:1504262423(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396028 196380322> (DF) (ttl 113, id 15701, len 1420)
05:05:17.632928 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504198127:1504199495(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380364> (DF) (ttl 113, id 15749, len 1420)
05:05:17.644118 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: P [tcp sum ok] 1504199495:1504200863(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380365> (DF) (ttl 113, id 15757, len 1420)
05:05:17.655056 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504200863:1504202231(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380367> (DF) (ttl 113, id 15763, len 1420)
05:05:17.657904 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504259687 win 62928 <nop,nop,timestamp 196380374 5396=
027> (DF) (ttl 63, id 13884, len 52)
05:05:17.658110 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504262423 win 62928 <nop,nop,timestamp 196380374 5396=
027> (DF) (ttl 63, id 13885, len 52)
05:05:17.658314 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504262423 win 62928 <nop,nop,timestamp 196380374 5396=
027,nop,nop,sack sack 1 {1504199495:1504200863} > (DF) (ttl 63, id 13886, l=
en 64)
05:05:17.658504 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504262423 win 62928 <nop,nop,timestamp 196380374 5396=
027,nop,nop,sack sack 1 {1504200863:1504202231} > (DF) (ttl 63, id 13887, l=
en 64)
05:05:17.666589 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504202231:1504203599(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380367> (DF) (ttl 113, id 15771, len 1420)
05:05:17.667456 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504262423 win 62928 <nop,nop,timestamp 196380375 5396=
027,nop,nop,sack sack 1 {1504202231:1504203599} > (DF) (ttl 63, id 13888, l=
en 64)
05:05:17.706849 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504259687:1504261055(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15784, len 1420)
05:05:17.707701 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504262423 win 62928 <nop,nop,timestamp 196380379 5396=
027,nop,nop,sack sack 1 {1504259687:1504261055} > (DF) (ttl 63, id 13889, l=
en 64)
05:05:17.717580 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504261055:1504262423(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15785, len 1420)
05:05:17.718422 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504262423 win 62928 <nop,nop,timestamp 196380380 5396=
033,nop,nop,sack sack 1 {1504261055:1504262423} > (DF) (ttl 63, id 13890, l=
en 64)
05:05:17.728750 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504262423:1504263791(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15786, len 1420)
05:05:17.729591 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504263791 win 61560 <nop,nop,timestamp 196380381 5396=
033> (DF) (ttl 63, id 13891, len 52)
05:05:17.740012 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504263791:1504265159(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15787, len 1420)
05:05:17.740847 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504265159 win 60192 <nop,nop,timestamp 196380382 5396=
033> (DF) (ttl 63, id 13892, len 52)
05:05:17.749256 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: P [tcp sum ok] 1504265159:1504266335(1176) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15788, len 1228)
05:05:17.750061 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504266335 win 59016 <nop,nop,timestamp 196380383 5396=
033> (DF) (ttl 63, id 13893, len 52)
05:05:17.760715 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504266335:1504267703(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15789, len 1420)
05:05:17.761541 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504267703 win 57648 <nop,nop,timestamp 196380384 5396=
033> (DF) (ttl 63, id 13894, len 52)
05:05:17.771597 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504267703:1504269071(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15790, len 1420)
05:05:17.772427 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504269071 win 56280 <nop,nop,timestamp 196380385 5396=
033> (DF) (ttl 63, id 13895, len 52)
05:05:17.783911 64.37.218.202.http > dsl-205-210-52-190.kingston.net.delibo=
: . [tcp sum ok] 1504269071:1504270439(1368) ack 943437539 win 16560 <nop,n=
op,timestamp 5396033 196380374> (DF) (ttl 113, id 15791, len 1420)
05:05:17.784752 dsl-205-210-52-190.kingston.net.delibo > 64.37.218.202.http=
: . [tcp sum ok] ack 1504270439 win 54912 <nop,nop,timestamp 196380386 5396=
033> (DF) (ttl 63, id 13896, len 52)

At 05:05:17.098927 the sender (64.37.218.202) sent the receiver (me,
dsl-205-210-52-190.kingston.net) the packet "1504196759:1504198127"
and at 05:05:17.099749 I sent the ack for it.  The next packet which
should be 1504198127:1504199495 gets lost somewhere but the sender
(not knowing one got lost) continues to send packats with the next one
"1504199495:1504200863" arriving at at 05:05:17.109846 and at
05:05:17.110703 I ack 1504198127 again, but this time the ack carried
a "sack" option.  No previous ack did this.  It seems that the ack
packets carrying the "sack" option did not make it to the sender
despite the SYN packet from the sender stating "sack" was permitted.
Perhaps the sender has a firewall dropping (or only permitting)
selected TCP options and packets with sack options are dropped.

I (the receiver) continued to send these acks (with the "sack" option
upto and including 05:05:17.589623, but the ack at 05:05:17.589623 is
the same except the sack option changes slightly.  This ack must make
it through because the sender resends "1504198127:1504199495" (twice
in fact -- remember this detail) and then at 05:05:17.657904 I ack all
of the data that was being sent while I was still acking 1504198127.
(Pretty cool I must say!  I always knew TCP worked this way but seeing
it in action is neat.)

Now where the tcp-window-tracking gets all fouled up is that it flags
the second resending of packet "1504198127:1504199495" as being sent
out-of-window but since the reciever has not acked the packet at this
point the window boundary should not be changed.  The acking of this
packet does not occur until .024976 of a second _after_ receiving the
second resent packet at which time the boundary of the window should
be changed.

Does all of this sound correct?

b.

P.S.:  I have not caught an example of an out-of-bounds window
situation with a SYN only packet yet, but I am waiting.  :-)

--=20
Brian J. Murrell

--E+IgQzR66AIOcbjA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE9z/Aol3EQlGLyuXARAnMXAKDPNijigheE4RjbPZWaue1nSSNvtgCg3M/3
YWyz5jy1z7F/s+wE4Yd/HFY=
=26R+
-----END PGP SIGNATURE-----

--E+IgQzR66AIOcbjA--
--E+IgQzR66AIOcbjA--
