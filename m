From: Matt Zimmerman <mdz@debian.org>
Subject: Re: [vendor-sec] [SECURITY] Netfilter Security Advisory: NAT Remote DOS (SACK mangle)
Date: Sat, 2 Aug 2003 13:03:00 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030802170259.GY24128@alcor.net>
References: <20030802143417.GB21074@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030802143417.GB21074@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Aug 02, 2003 at 04:34:17PM +0200, Netfilter Core Team wrote:

> Systems Affected:
> 
>   Linux 2.4.20 kernels and recent 2.5 kernels with
>   CONFIG_IP_NF_NAT_FTP or CONFIG_IP_NF_NAT_IRC enabled, or the
>   ip_nat_ftp or ip_nat_irc modules loaded, on which ftp and irc users
>   are not packet filtered out.

The other advisory contained an explicit statement about kernels other than
the ones mentioned, but this one did not.  So, just to clarify, am I correct
in inferring that pre-2.4.20 kernels are NOT affected by this bug?



-- 
 - mdz
