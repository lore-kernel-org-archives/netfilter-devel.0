From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.4.4 released
Date: Thu, 13 Nov 2008 10:43:31 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0811131040050.9639@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

I'm happy to announce the new version of ipset - the list of the changes 
is as follows:

  - Premature checking prevents to add valid elements to hash
    types, fixed (bug reported by JC Janos).
  - Local variable shadows another variable, fixed (reported
    by Jan Engelhardt).
  - More compiler warning options added and warnings fixed.

You can download the source of ipset from the webpage or svn:

        http://ipset.netfilter.org/
        svn co https://svn.netfilter.org/netfilter/trunk/ipset

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
