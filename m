From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.32 released
Date: Sun, 12 Mar 2017 20:18:51 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1703122015570.7740@blackhole.kfki.hu>
References: <alpine.DEB.2.11.1703121853070.7464@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1703121853070.7464@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 12 Mar 2017, Jozsef Kadlecsik wrote:

> ipset 6.32 has been released, with just userspace part changes. 
> Omri Bahumi and Yoni Lavi discovered that due to the inproper handling of 
> the ipset output buffer, the output may be truncated. So for example in an 
> "ipset save" output, instead of 192.168.0.0/24, just 192.168.0.0 printed.

Small correction: it could also be truncated to "192.168.0.0/2", with all 
its implication when that is restored.

> If you use "ipset save" and then "ipset restore" to restore the sets, this 
> may lead to wrong firewall rules.
> 
> Please upgrade your ipset package.
> 
> Userspace changes:
>   - Fix possible truncated output in ipset output buffer handling
>     (Reported by Omri Bahumi and Yoni Lavi).
>   - Missing prototype added in ipset_hash_ipmac.c (debugging)
> 
> You can download the source code of ipset from:
>         http://ipset.netfilter.org
>         ftp://ftp.netfilter.org/pub/ipset/
>         git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
