From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH][NET] update Kconfig files for bridging firewall
Date: Sat, 23 Aug 2003 10:49:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308231049.05257.bdschuym@pandora.be>
References: <200308231032.55831.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	ebtables-devel <ebtables-devel@lists.sourceforge.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
In-Reply-To: <200308231032.55831.bdschuym@pandora.be>
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

netfilter-devel can ignore this message, the message was meant to be CC'ed to 
ebtables-devel.

Sorry for the overhead.

cheers,
Bart

On Saturday 23 August 2003 10:32, Bart De Schuymer wrote:
> Hi Dave,
>
> The patch below adds some comments about filtering bridged ARP traffic and
> using netfilter for a bridging firewall. It also makes a menu for the
> ebtables configuration, which makes it look like the IP, IPv6 and DECnet
> filtering configuration.
>
> This patch is an incremental patch, it assumes you applied the arpreply
> patch I sent yesterday. It is vs the Linux kernel snapshot (bk10) from
> yesterday.
