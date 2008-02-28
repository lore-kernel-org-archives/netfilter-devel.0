From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: helpers register for a specific port, but work anyway
Date: Thu, 28 Feb 2008 08:18:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802280814270.14171@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802271534551.12047@blackhole.kfki.hu>
 <Pine.LNX.4.64.0802271758460.5388@fbirervta.pbzchgretzou.qr>
 <47C59A08.9080802@trash.net> <Pine.LNX.4.64.0802272346160.5388@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:36756 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbYB1HSz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:18:55 -0500
In-Reply-To: <Pine.LNX.4.64.0802272346160.5388@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 27 Feb 2008, Jan Engelhardt wrote:

> >> # iptables -t nat -A PREROUTING -d 134.76.12.5 -p tcp --dport 2121
> >>  -j DNAT --to 134.76.12.5:21
> >> 
> >> and on the client (192.168.222.24),:
> >> 
> >> # conntrack -E expect &
> >> # ftp 134.76.12.5 2121
> >> Connected to ftp5.gwdg.de.
> >> 220 "Welcome to FTP5.GWDG.DE."
> >> Name (ftp5.gwdg.de:jengelh): ftp
> >> 331 Please specify the password.
> >> Password:
> >> 230 Login successful.
> >> Remote system type is UNIX.
> >> Using binary mode to transfer files.
> >> ftp> dir
> >> 300 proto=6 src=192.168.222.24 dst=134.76.12.5 sport=0 dport=32238
> >> 229 Entering Extended Passive Mode (|||32238|)
> >> 150 Here comes the directory listing.
> >> drwx------    2 ftp      ftp         16384 Apr 20  2006 lost+found
> >> drwxr-xr-x   33 ftp      ftp          4096 Feb 27 00:58 pub
> >> 226 Directory send OK.
> >> ftp>
> >> 
> >> The 300 proto=6 line comes from conntrack -E --- but if nf_conntrack_ftp
> >> does not parse streams to port 2121 by default, how could it have
> >> set up the expectation?
> >
> > When NATing packets the helper lookup is repeated based
> > on the final tuple.
> 
> But the machine I am running conntrack -E and ftp from do not
> see the NATting taking place higher up in the routing chain, do they?

You had to load the nf_conntrack_ftp module on the client machine too.
By which module parameters was it loaded?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
