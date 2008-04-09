From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [announce] Xtables-addons 1.5.4
Date: Wed, 9 Apr 2008 22:07:20 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804092136250.17930@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Brent Clark <brentgclarklist@gmail.com>,
	Krzysztof Oledzki <ole@ans.pl>,
	Massimiliano Hofer <max@nucleus.it>
To: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, lartc@mailman.ds9a.nl
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi everyone,


Xtables-addons 1.5.4 has been released; highlights of this release are 
the import, cleanup/bugfixing the "condition" and "ipp2p" matches and 
additionally extending the "IPMARK" by IPv6. I hope people don't mind, 
but I have not heard back so far, so I take it it's ok.
LOGMARK (for analyzing packet marks and connection states) now prints 
the invoking hook and the packet direction. There is now also a compiled 
manpage that lists all matches' and targets' options, plus a few fixes 
to the TEE target.

Tarball:
	http://dev.computergmbh.de/files/xtables/xtables-1.5.3.tar.bz2 +
	http://dev.computergmbh.de/files/xtables/xtables-addons-1.5.4.tar.bz2

or alternatively a two-in-one pack:
	http://dev.computergmbh.de/files/xtables/xtables-combined-1.5.4.tar.bz2

Repository (gitweb), for "short"log and all that:
	http://dev.computergmbh.de/gitweb.cgi?p=xtables-addons


that's it for now, have fun,
Jan

- - - -
  About Xtables-addons.
      Xtables-addons is the proclaimed successor to patch-o-matic(-ng). 
Likewise, it contains extensions that were not accepted in the main 
iptables package [so far].
Xtables-addons is different from patch-o-matic in that you do not have
to patch or recompile the kernel. [Supported kernels versions are 
2.6.18--2.6.25;; not all p-o-matic patches can be transformed.]
A big benefit of the compat layer of xtables-addons is that the actual 
modules remain largely free of #ifdef hackery and hence make maintenance 
a lot easier.

  Current list of bundled extensions.
CHAOS DELUDE IPMARK LOGMARK TARPIT condition geoip ipp2p portscan
