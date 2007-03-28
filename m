From: "Jay Manni" <JManni@FireEye.com>
Subject: RE: unregister_netdevice with negative refcnt error while using
	NFQUEUE with ebtables mark
Date: Wed, 28 Mar 2007 16:34:57 -0700
Message-ID: <74ECB30468A30A4DA2BD88DA5387CAE3508AEB@fempexch.FireEye.com>
References: <74ECB30468A30A4DA2BD88DA5387CAE3508835@fempexch.FireEye.com>
	<46093551.2060906@trash.net>
	<74ECB30468A30A4DA2BD88DA5387CAE3508A49@fempexch.FireEye.com>
	<460A3653.6020501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
In-Reply-To: <460A3653.6020501@trash.net>
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

I have a bridge br0, with a couple of tap interfaces tap0, tap1 etc as =
part of it. I use the following ebtables rules to mark packets =
originating from a bridge port and destined to it.

ebtables -t broute -A BROUTING -i tap0 -p ipv4 -j mark --mark-set 10
ebtables -t nat    -A POSTROUTING -o tap0 -p ipv4 -j mark --mark-set 20

Then the following iptables rules to send them to an NFQUEUE

iptables -t mangle -A PREROUTING  -m mark --mark 10 -j NFQUEUE --queue 5
iptables -t mangle -A POSTROUTING -m mark --mark 20 -j NFQUEUE --queue 5 =


The tap interfaces do not have any ip address configured.

Based on the detailed packet flow picture at =
http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png, I figured that =
the above rules would get me all the packets for the tap interface in =
question.

The process which attaches to NFQUEUE 5 does receive all the packets, =
and sets a verdict of NF_ACCEPT for each packet. However when I try to =
free the interfaces after it is done, I notice that the tap device has a =
negative refcnt.

- jay=20

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Wednesday, March 28, 2007 2:33 AM
To: Jay Manni
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: unregister_netdevice with negative refcnt error while using =
NFQUEUE with ebtables mark

Jay Manni wrote:
> Kernel version - 2.6.15.4
> I am using the nfnetlink_queue and haven't been able to reproduce =
without queueing.


Please send the exact commands you use for queueing
and whether these packets are bridged or routed.

--=20
Internal Virus Database is out-of-date.
Checked by AVG Free Edition.
Version: 7.5.432 / Virus Database: 268.16.7/619 - Release Date: 1/7/2007 =
6:29 PM
=20

--=20
Internal Virus Database is out-of-date.
Checked by AVG Free Edition.
Version: 7.5.432 / Virus Database: 268.16.7/619 - Release Date: 1/7/2007 =
6:29 PM
=20
