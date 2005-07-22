From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: (Probably) it's a bug
Date: Fri, 22 Jul 2005 14:49:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0507221443060.9072@bizon.gios.gov.pl>
References: <20050721194841Z1186111-31917+1237@kps8.test.onet.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1533615305-1122036561=:9072"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marek Sirdak <marek@nevision.net>
In-Reply-To: <20050721194841Z1186111-31917+1237@kps8.test.onet.pl>
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

---187430788-1533615305-1122036561=:9072
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 21 Jul 2005, Marek Sirdak wrote:

> Dear Netfilter developers:
>
> I'm using iptables to protect my company network. My Kernel version is
> 2.6.12 and iptables 1.3.2. Today I noticed that iptables cannot control
> broadcast traffic. For example I'm using DHCPd (version 3.0.2).

Hm.. isc-dhcpd uses af_packet:

Symbol: PACKET [=3Dy]
  Prompt: Packet socket
    Defined at net/Kconfig:26
    Depends on: NET
    Location:
      -> Device Drivers
        -> Networking support
          -> Networking support (NET [=3Dy])
            -> Networking options

"The Packet protocol is used by applications which communicate
  directly with network devices without an intermediate network
  protocol implemented in the kernel, e.g. tcpdump.  If you want them
  to work, choose Y.

(...)"

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1533615305-1122036561=:9072--
