From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: RE: xt_gateway 20070605 (kernel)
Date: Sat, 16 Jun 2007 14:00:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706161358480.32724@fbirervta.pbzchgretzou.qr>
References: <200706161052.l5GAqYv25389@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706161052.l5GAqYv25389@server1.secure-linux-server.com>
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


On Jun 16 2007 10:29, Amin Azez wrote:
>
>= (b) rules from the distribution (e.g. =/etc/sysconfig/network/ifroutes)
>=    [lesser a problem]
>
>Likewise, scope helped recognize these.

ip r: (created by)

10.0.254.1 via 10.0.254.5 dev tun0 (openvpn)
10.0.254.5 dev tun0  proto kernel  scope link  src 10.0.254.6 (openvpn)
192.168.254.0/24 via 10.0.254.5 dev tun0 (openvpn)
192.168.222.0/24 dev eth1  proto kernel  scope link  src 192.168.222.1 (distro)
192.168.60.0/22 dev vmnet1  proto kernel  scope link  src 192.168.60.1 (vmware)
10.10.96.0/20 dev eth0  proto kernel  scope link  src 10.10.106.161 (distro)
169.254.0.0/16 dev eth0  scope link (distro)
127.0.0.0/8 dev lo  scope link  (distro)
default via 10.10.96.1 dev eth0  (distro)

Hm! Not much to save :)

>>What would they care about how it's done?
>
>They might prefer that anything that made things easier were not available
>outside of the source CD that we ship with the box. There is no official
>company policy on this yet, and I prefer it that way.

One could obtain the CD and then redistribute the GPL components, and we'd
be where we are now. It does not buy the corp.s anything by limiting
distribution. In fact, spread it, and let others do the work ^_^.


	Jan
-- 
