From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: helpers register for a specific port, but work anyway
Date: Wed, 27 Feb 2008 23:47:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802272346160.5388@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802271534551.12047@blackhole.kfki.hu>
 <Pine.LNX.4.64.0802271758460.5388@fbirervta.pbzchgretzou.qr>
 <47C59A08.9080802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44225 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018AbYB0WrP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:47:15 -0500
In-Reply-To: <47C59A08.9080802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 27 2008 18:12, Patrick McHardy wrote:
>> > Why do you think so? Ports not specified as FTP command ports are not
>> > parsed.
>> 
>> Yes, I find it strange. On the router (192.168.222.1), I do:
>> 
>> # iptables -t nat -A PREROUTING -d 134.76.12.5 -p tcp --dport 2121
>>  -j DNAT --to 134.76.12.5:21
>> 
>> and on the client (192.168.222.24),:
>> 
>> # conntrack -E expect &
>> # ftp 134.76.12.5 2121
>> Connected to ftp5.gwdg.de.
>> 220 "Welcome to FTP5.GWDG.DE."
>> Name (ftp5.gwdg.de:jengelh): ftp
>> 331 Please specify the password.
>> Password:
>> 230 Login successful.
>> Remote system type is UNIX.
>> Using binary mode to transfer files.
>> ftp> dir
>> 300 proto=6 src=192.168.222.24 dst=134.76.12.5 sport=0 dport=32238
>> 229 Entering Extended Passive Mode (|||32238|)
>> 150 Here comes the directory listing.
>> drwx------    2 ftp      ftp         16384 Apr 20  2006 lost+found
>> drwxr-xr-x   33 ftp      ftp          4096 Feb 27 00:58 pub
>> 226 Directory send OK.
>> ftp>
>> 
>> The 300 proto=6 line comes from conntrack -E --- but if nf_conntrack_ftp
>> does not parse streams to port 2121 by default, how could it have
>> set up the expectation?
>
> When NATing packets the helper lookup is repeated based
> on the final tuple.

But the machine I am running conntrack -E and ftp from do not
see the NATting taking place higher up in the routing chain, do they?
