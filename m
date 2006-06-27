From: Patrick McHardy <kaber@trash.net>
Subject: Re: pppd stuck in ioctl(TIOCSETD) in Linux 2.6.15.4+
Date: Wed, 28 Jun 2006 00:43:14 +0200
Message-ID: <44A1B482.80901@trash.net>
References: <004b01c69a3a$6b80c660$0201a8c0@athlon64>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-ppp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-ppp-owner@vger.kernel.org>
To: Jorge Daniel Sequeira Matias <martin@andorinha.ist.utl.pt>
In-Reply-To: <004b01c69a3a$6b80c660$0201a8c0@athlon64>
Sender: linux-ppp-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jorge Daniel Sequeira Matias wrote:
> 
>  Hi everyone,
> 
>  I'm running a PPTP VPN Server for almost 4 years now. This server is
> running in a Debian Linux (unstable).
>  The configuration for the last 1 year and a half was the following:
> 
>  Computer 2x Intel Xeon 2.6GHz and 512MB RAM
>  Linux v2.6.11.6 (vanilla) with MPPE patch
>  Debian distribution with the following packages
>     - pppd 2.4.3-20050321
>     - libradius1 0.3.2-8
>     - radiusclient1 0.3.2-8
> 
>  With this configuration I had reach a peek of aprox. 600 hundred PPTP
> connections simultaneously. The computer gets heavy loaded doing MPPE
> compression/decompression with 40Mbits/sec of PPP traffic but didn't
> have any problem with this setup. The authentication process is using a
> pool of RADIUS servers.
> 
>   This machine is also a firewall, and now a new feature was needed:
> PPTP VPN connections from the inside.
> 
>  The problem:
> 
>   After the upgrade to a Linux v2.6.15.4 (vanilla) with no patches to
> use the new "ip_conntrack_pptp" module, I started to get "pppd"
> processes hanging in "S" state and consuming CPU power.

Does the problem go away without the ip_conntrack_pptp module loaded?
