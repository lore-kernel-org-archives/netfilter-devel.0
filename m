From: Martin Schulze <joey@infodrom.org>
Subject: Re: a small bug in iptables.c and ip6tables.c get_modprobe()
Date: Tue, 26 Oct 2004 16:09:31 +0200
Message-ID: <20041026140931.GA19643@finlandia.infodrom.north.de>
References: <20041013235342.GD4827@nalle>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: 219686@bugs.debian.org, debian-firewall@lists.debian.org,
	netfilter-devel@lists.netfilter.org
Return-path: <bounce-debian-firewall=debian-firewall=m.gmane.org@lists.debian.org>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Content-Disposition: inline
In-Reply-To: <20041013235342.GD4827@nalle>
Resent-Message-ID: <HPG9uC.A.jZD.9ylfBB@murphy>
List-Post: <mailto:debian-firewall@lists.debian.org>
List-Help: <mailto:debian-firewall-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-firewall-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-firewall-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-firewall/>
List-Id: netfilter-devel.vger.kernel.org

Mikko Rapeli wrote:
> Hello,
> 
> This #219686 Lokkit bug in Debian is not actually a Lokkit bug but an iptables
> bug, heh. Firewall or other scripts should not have to load iptables 
> modules since iptables the executable can do it for them. strace and gdb
> showed - after some head scratching - why an 'iptables -L' or 
> 'iptables -N foo' loaded the modules but 'iptables -N RH-Lokkit-0-50-INPUT' 
> did not.
> 
> Attached patches fixes this in iptables 1.2.9, which is now in Debian
> testing, and they also apply to the latest 1.2.11 from netfilter.org.

Thanks a lot Mikko!  This problem has been assigned CAN-2004-0986.

-- 
Testing? What's that? If it compiles, it is good, if it boots up, it is perfect.

Please always Cc to me when replying to me on the lists.
