From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.21 released
Date: Thu, 6 Mar 2014 10:25:59 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1403061024450.27979@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1403042207250.17838@blackhole.kfki.hu> <5316CC91.2080704@fastest.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: AllKind <AllKind@fastest.cc>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <5316CC91.2080704@fastest.cc>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Wed, 5 Mar 2014, AllKind wrote:

> On 04.03.2014 22:12, Jozsef Kadlecsik wrote:
> > Hi,
> > 
> > I'm happy to announce ipset 6.21, which, besides bugfixes and corrections,
> > includes the new set type hash:ip,mark from Vytas Dauksa and the forceadd
> > option from Josh Hunt. See the updated manpage about these new features.
> [...]
> Hello,
> 
> unfortunately the utils were not updated with this release.

Oh, I forgot to pull the changes - I'm going to release 6.21.1 with the 
utils updated.

Best regards,
Jozsef
  
> You can download the newest version of ipset_bash_completion including
> markmask and forceadd support from here:
> 
> https://sourceforge.net/projects/ipset-bashcompl/files/latest/download?source=navbar
> 
> 
> Also a newer and more powerful version of ipset_list is available here:
> 
> https://sourceforge.net/projects/ipset-list/files/latest/download
> 
> 
> Something that also might be useful to you is the current development version
> of iptables-bash_completion, which includes the features that are currently
> only available via the netfilter git repository:
> 
> https://sourceforge.net/p/ipt-bashcompl/code/ci/dev/tree/
> 
> Best regards
> 
> AllKind
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
