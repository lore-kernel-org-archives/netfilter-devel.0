From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCEMENT] ipset-2.3.1 released
Date: Thu, 12 Jun 2008 12:01:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806121135040.2250@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

I'm happy to release a new version of ipset. This is a bugfix release, no 
new features added. The list of the fixes:

- kernel part: a nasty typo which can lead to kernel crash when 
  creating a set is fixed in the macipmap type
- userspace tool:
  - segfault on --unbind :all: :all: fixed (reported by cheetah and Tom 
    Eastep)
  - User input parameters are sanitized everywhere
  - Initial testsuite added: few bugs discovered and fixed
    - typo in macipmap type prevented to use max size set of this type
    - *map types are made sure to allow and use max size of sets

You can download the ipset-1.3.1 source tree and the patch-o-matic-ng 
snapshot from http://ipset.netfilter.org/.

The sources can be downloaded directly from the git and svn repositories
as well:

- patch-o-matic-ng from git: git://git.netfilter.org/patch-o-matic-ng.git
- ipset from svn: https://svn.netfilter.org/netfilter/trunk/ipset

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
