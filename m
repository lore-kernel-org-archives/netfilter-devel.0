From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: H.323 progress.
Date: Tue, 18 May 2004 10:06:10 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <2291.1084889170@marajade.sandelman.ottawa.on.ca>
References: <40A9431D.8020404@sauce.co.nz>
Reply-To: users@lists.openswan.org
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard Scobie <richard@sauce.co.nz>
In-Reply-To: Message from Richard Scobie <richard@sauce.co.nz>
   of "Tue, 18 May 2004 10:56:29 +1200." <40A9431D.8020404@sauce.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----


>>>>> "Richard" == Richard Scobie <richard@sauce.co.nz> writes:
    Richard> I have a FreeSwan IPsec VPN between 2 iptables NAT boxes.

  Okay. But this, you mean that you have two boxes that normally perform
NAT, but the VPN otherwise connects the two private networks? (I am
asking to confirm this)

    Richard> With H.323 videoconferencing equipment from both Via Video
    Richard> and Tandberg, I have been unable to get complete connection
    Richard> between both ends through the VPN - 90+ % of the time,
    Richard> video connects both ways and audio only one.

  I'm ignorant of how the proxies work. If you have a VPN, why do you
need them?  I'd think you need them only when trying to pass through the
NAT, rather than go around it.
  
- --
]     "Elmo went to the wrong fundraiser" - The Simpson         |  firewalls  [
]   Michael Richardson,    Xelerance Corporation, Ottawa, ON    |net architect[
] mcr@xelerance.com      http://www.sandelman.ottawa.on.ca/mcr/ |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)
Comment: Finger me for keys

iQCVAwUBQKoYS4qHRg3pndX9AQH8bAQAzMlS18fG+h7meTTjO4GmicaCZMhmui/q
IeHkzJI0rPx6QlGGDG8EvohOkltKAvHv3gi6NuzY7XsOq3AoGdlcjHwqXCPTOgdw
iYkd83NLbboX6yF7+CBavt2tH5PAJu2WNHVlIq9YwKXKyEysv9eAm/1dqSVIrZMk
pC4CkmSS1yM=
=LoQC
-----END PGP SIGNATURE-----
