From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack
Date: Tue, 4 Mar 2003 08:33:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030304073324.GI25876@oknodo.bof.de>
References: <200303040107.28400.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Micha? Margula <alchemyx@uznam.net.pl>
Content-Disposition: inline
In-Reply-To: <200303040107.28400.alchemyx@uznam.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> ip_conntrack: table full, dropping packet.
> Doing
> echo 256000 > /proc/net/ip_conntrack
> Does not help.

Sigh.  Your command is not supposed to work.  Use:

echo 256000 > /proc/sys/net/ipv4/ip_conntrack_max

regards
  Patrick
