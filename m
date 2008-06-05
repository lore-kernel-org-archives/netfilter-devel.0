From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Thu, 05 Jun 2008 19:11:11 +0200
Message-ID: <x663snremo@gzp>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>
	<483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp>
	<483C088E.4020405@trash.net> <x67idfq6d8@gzp>
	<483CFF21.40608@trash.net> <4847F64C.2040902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy <kaber@trash.net>:

| Took me a bit longer. I've resynced all headers and added
| a recent linux/types.h. Does this patch (on top of 1.4.1-rc2)
| fix compilation?

patching file include/linux/netfilter.h
Reversed (or previously applied) patch detected!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file include/linux/netfilter.h.rej

make  all-recursive
make[1]: Entering directory `/home/gzp/src/iptables-1.4.1-rc2'
Making all in extensions
make[2]: Entering directory `/home/gzp/src/iptables-1.4.1-rc2/extensions'

[...]

  CC       libxt_dccp.oo
libxt_dccp.c:16:24: warning: linux/dccp.h: No such file or directory

[...]

make[2]: *** [libxt_dccp.oo] Error 1
make[2]: Leaving directory
`/home/gzp/src/iptables-1.4.1-rc2/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2'
make: *** [all] Error 2
