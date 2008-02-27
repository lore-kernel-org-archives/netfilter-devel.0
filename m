From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: helpers register for a specific port, but work anyway
Date: Wed, 27 Feb 2008 18:08:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802271758460.5388@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802271534551.12047@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37284 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbYB0RIP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:08:15 -0500
In-Reply-To: <Pine.LNX.4.64.0802271534551.12047@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 27 2008 15:36, Jozsef Kadlecsik wrote:
>
>On Wed, 27 Feb 2008, Jan Engelhardt wrote:
>
>> in nf_conntrack_ftp.c for example we find
>> 
>>              ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);
>> 
>> assuming the user does not specify any ports on modprobe, the default 
>> port list defaults to {21}, so ftp[0][x].tuple.src will contain port 21. 
>> But even ftp connections to non-21 ports are inspected for PORT 
>> commands. 
>
>Why do you think so? Ports not specified as FTP command ports are not 
>parsed.

Yes, I find it strange. On the router (192.168.222.1), I do:

# iptables -t nat -A PREROUTING -d 134.76.12.5 -p tcp --dport 2121
	-j DNAT --to 134.76.12.5:21

and on the client (192.168.222.24),:

# conntrack -E expect &
# ftp 134.76.12.5 2121
Connected to ftp5.gwdg.de.
220 "Welcome to FTP5.GWDG.DE."
Name (ftp5.gwdg.de:jengelh): ftp
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> dir
300 proto=6 src=192.168.222.24 dst=134.76.12.5 sport=0 dport=32238
229 Entering Extended Passive Mode (|||32238|)
150 Here comes the directory listing.
drwx------    2 ftp      ftp         16384 Apr 20  2006 lost+found
drwxr-xr-x   33 ftp      ftp          4096 Feb 27 00:58 pub
226 Directory send OK.
ftp>

The 300 proto=6 line comes from conntrack -E --- but if nf_conntrack_ftp
does not parse streams to port 2121 by default, how could it have
set up the expectation?

Case 2. On the router:
# iptables -t nat -A PREROUTING -p tcp --dport 2121 -j REDIRECT --to-ports 21
# rcvsftpd start

On the client:
# ftp 192.168.222.1 2121
Connected to 192.168.222.1.
220 (vsFTPd 2.0.5)
Name (192.168.222.1:jengelh): ftp
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> dir
229 Entering Extended Passive Mode (|||7366|)
150 Here comes the directory listing.
226 Directory send OK.

and this does not analyze ftp, just as I would have guessed from the C code.
But what's with case 1?
