From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Tue, 21 Oct 2008 23:05:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
 <alpine.LNX.1.10.0810212240190.30799@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0810212240190.30799@bizon.gios.gov.pl>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 21 Oct 2008, Krzysztof Oledzki wrote:

> # element separator token changed to ',' in anticipating IPv6 addresses, old
> separator tokens are still supported
> 
> # cat  aqq
> -N aqq macipmap --from 1.2.3.1 --to 1.2.3.10
> -A aqq 1.2.3.10,11:22:33:44:55:66
> COMMIT
> 
> # cat aqq|ipset -R
> Warning: please replace old separator character ':22:33:44:55:66.1' with ','.
> Next release won't support it.
> 
> OK, so what we are deprecating here? The recently introduced '%' separator or
> also the ':' mac address separator?

No, the separator between the different kind of elements, i.e. between IP 
address and port or between IP address and MAC address. The token 
separators inside IPv4(/IPv6) and MAC addresses remain the usual ones.

That message is just misleading and I'm going to fix it.

Sorry for the mess created by introducing earlier the '%' as a separator,
that was a bad choice. :-(

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
