From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 1 Jul 2012 14:37:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4FF04038.4080306@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 1 Jul 2012, Mr Dash Four wrote:

> 
> > The hash:net,iface type is out for a long time. It is not possible to change
> > the meaning of src/dst without breaking backward compatibility, therefore I
> > won't do it.
> It has nothing to do with "backward compatibility" at all, but everything to
> do with something which was done wrong initially and needs to be fixed. The
> fact that this "has been out for a long time" is not an excuse - if anything,
> it reflects pretty badly that this wasn't spotted earlier. Besides, when a bug
> is discovered do you write a man page documenting it or do you fix that
> particular bug?

Call it a bug, whatever. I won't change the meaning of src/dst for 
hash:net,iface which then will break someone's working firewall after an 
upgrade.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
