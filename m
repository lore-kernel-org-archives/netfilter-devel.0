From: =?ISO-8859-1?Q?Boris_Bartolom=E9?=
 <Boris.Bartolome@recherche.enac.fr>
Subject: Application to allow seamless connection to a network
Date: Thu, 19 Jun 2003 18:22:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EF1E35B.6090305@recherche.enac.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello all,

I am a long-time Linux user and a newbie programmer, but above
all I am a network engineer trying to build a new network
software using Linux.

My main objective is to allow a user using 802.11 to seamlessly connect to my network. I would like the Linux box to accept any new laptop whatever
his network configuration may be. If the user were configured
as a DHCP client, then a DHCP server running in the Linux box
would assign him an address (that's the easy part ...) If the
user were configured with static network data then the box
would kind of NAT whatever configuration the user has to the
network parameters needed to establish a standard connection
(IP address, DNS, proxy, ...) and "trick" all the network
applications by sending out nicely configured packets for that
user, mainly by using the user's MAC address as the identifier.

I know this program has already been built in the commercial domain on VxWorks (see http://www.nomadix.com)


I would like to know if:

1. That has already been done in the Linux world
2. If not, do you think netfilter would be a good basement
onto which to build my application/kernel module.

I am kind of lost now and would really appreciate any help you
could give me.

Best regards,

Boris Bartolome
