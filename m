From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_acct 1.0.3 release
Date: Mon, 22 Aug 2016 13:25:03 +0200
Message-ID: <20160822112503.GA3088@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Cc: lwn@lwn.net
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project presents:

        libnetfilter_acct 1.0.3

libnetfilter_acct is the userspace library providing interface to
extended accounting infrastructure.

See ChangeLog that comes attached to this email for more details.

You can download it from:

ftp://ftp.netfilter.org/pub/libnetfilter_acct/
http://www.netfilter.org/projects/libnetfilter_acct/downloads.html

Have fun!

P.S: I'm updating the website at this moment, so first link to FTP
allows you a quick fetch of the package.


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnetfilter_acct-1.0.3.txt"

Alexey Perevalov (1):
      Fix overquota output result

Eric Leblond (1):
      xml: fix inversion between pkt and bytes

Felix Janda (1):
      include: Sync with kernel headers

Gustavo Zacarias (1):
      configure: uclinux is also linux

Harald Welte (1):
      add JSON output format

Mathieu Poirier (1):
      Extend accounting capabilities to support quotas

Mr Dash Four (1):
      use PRIu64 and remove unnecessary cast

Pablo Neira Ayuso (4):
      include: use C++ headers in C++ mode
      include: remove sys/types.h
      src: fix broken output handling
      build: bump version to 1.0.3


--/04w6evG8XlLl3ft--
