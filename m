From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 1 Jul 2012 14:52:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com> <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
 <4FF04647.7060807@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4FF04647.7060807@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 1 Jul 2012, Mr Dash Four wrote:

> > Call it a bug, whatever. I won't change the meaning of src/dst for
> > hash:net,iface which then will break someone's working firewall after an
> > upgrade.
> >   
> In other words, you are not only intent on keeping this bug in the
> netfilter/kernel code, but willing to document it in a man page simply because
> of the remote possibility that someone somewhere may have been using
> hash:net,iface and decided to upgrade while not willing to change its
> configuration to put right something which was wrong in the first place?

Yes. You argue the meaning of a keyword. The meaning is well documented in 
the manpage, but it's totally counter-intuitive for you. Changing the 
meaning might break working firewalls. Therefore the meaning won't be 
changed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
