From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.9
Date: Tue, 03 Aug 2010 19:25:55 +0200
Message-ID: <x6lj8nwqu4@gzp>
References: <4C5832F9.50004@trash.net> <x6bp9jy7sj@gzp>
	<4C584C63.8010607@trash.net> <x6vd7rwrah@gzp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Linux Netdev List <netdev@vger.kernel.org>,
	"'netfilter\@vger.kernel.org'" <netfilter@vger.kernel.org>,
	netfilter-announce@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* "Gabor Z. Papp" <gzp@papp.hu>:

| Note the difference, new undefined reference: `libxt_IDLETIMER_init

--disable-shared --enable-static configure options cause the problems.

--enable-shared --disable-static compiles fine, but I would like to
link against the static libs.
