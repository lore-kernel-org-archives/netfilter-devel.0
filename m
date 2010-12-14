From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: 6to4/Teredo IPv4 matching
Date: Tue, 14 Dec 2010 21:29:39 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012142127270.3226@blackhole.kfki.hu>
References: <201012140940.11119.luke@dashjr.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Luke-Jr <luke@dashjr.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201012140940.11119.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, 14 Dec 2010, Luke-Jr wrote:

> Are there any plans to allow matching 6to4/Teredo IPv6 packets against IPv4 
> rules (or at least ipsets)? Recently I have a server that's been under 
> constant DDoS from China, and I found that when I use ipsets to drop 
> everything from China, some continue to hammer my server over 6to4 and/or 
> Teredo. So I just figured I'd throw the idea out there in case it hasn't 
> occurred to anyone yet. ;)

ipset 5 is about to be released in this week, with both IPv4 and IPv6 
support. But feeding the sets with the proper addresses/networks is left 
to the users :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
