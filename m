From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: 2.4.20: MASQ firewall is losing TCP sessions [tcpdumped]
Date: 15 Jun 2003 20:36:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1055702217.3214.10.camel@tux.rsn.bth.se>
References: <200306152055.45490.insecure@mail.od.ua>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: insecure@mail.od.ua, vda@port.imtp.ilyichevsk.odessa.ua
In-Reply-To: <200306152055.45490.insecure@mail.od.ua>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-06-15 at 19:55, insecure wrote:

> Looks like firewall forgot about our connection. What's going on?
> 
> Kernel: 2.4.20, .config is at the end of this mail.

Kernel 2.4.20 has a very serious problem with ip_conntrack.
It has been corrected in 2.4.21 so please upgrade.

> I'd be happy to provide more info on known connections and the like,
> but I failed to find an iptables equivalent of ipchains -M. :(

cat /proc/net/ip_conntrack

Upgrade to 2.4.21, if that doesn't work you can provide more info.

-- 
/Martin
