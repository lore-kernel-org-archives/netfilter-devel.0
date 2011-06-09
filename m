From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: FTP Packet Mangling & NAT
Date: Thu, 09 Jun 2011 15:20:08 +1200
Message-ID: <81c0aab748c6ad27b289055e31777945@treenet.co.nz>
References: <BANLkTintTA8T_FEqF-vWe85iTonfZHGn3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: Nadeem Douba <ndouba@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:36454
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1FID3K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:29:10 -0400
In-Reply-To: <BANLkTintTA8T_FEqF-vWe85iTonfZHGn3w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 On Wed, 8 Jun 2011 16:18:11 -0400, Nadeem Douba wrote:
> Hi all,
>
> I have an interesting scenario where I have a transparent proxy that
> does some funny things with PASSIVE=C2=A0FTP communications that is m=
aking
> me think of developing a netfilters module to correct the behavior.
> What is going on is the following:
>
> 1. Client establishes connection to FTP server s1.s2.s3.s4 via
> transparent proxy (where s1, s2, s3, s4 is the first, second, third,
> and fourth octet of the IPv4 address for the remote server,
> respectively)
> 2. Client sends PASV command to FTP server indicating that the client
> will be using a PASSIVE FTP connection for its data channel
> 3. Server responds with '227 Entering Passive Mode
> (tp1,tp2,tp3,tp4,p1,p2).' (where t1, t2, t3, t4 is the first, second,
> third, and fourth octet of the IPv4 address for the transparent=20
> proxy,
> respectively. Where p1 and p2 are the higher and lower order octets
> for the remote TCP port, respectively)
>
> In step three, the transparent proxy modifies the server's original
> response to the PASV command by translating what should have been=20
> '227
> Entering Passive Mode (s1,s2,s3,s4,p1,p2).' to '227 Entering Passive
> Mode (tp1,tp2,tp3,tp4,p1,p2).'. Some clients (like IE and Firefox)
> don't like this at all and this results in a broken FTP session.

 The proxy completely controls what the client gets given. It is=20
 breaking transparency by not reverse-mapping the response properly.=20
 Mention it to the authors and get it fixed.

>
> This is where a custom netfilters module would come in handy. I'd=20
> like
> to be able to "untranslate" the server's response back into it's
> original form. However, the transparent proxy expects to broker the
> passive data channel at the same time, so simply fixing the response
> would break the communications to and from the FTP server. Therefore,
> in addition to fixing the server's response, I need to do some=20
> NAT'ing
> on all data channel packets. I was wondering if anybody could help
> point me in the right direction with regards to developing such a
> module. The flow would be as follows:
>
> 1. module detects PASV response '227 Entering Passive Mode
> (tp1,tp2,tp3,tp4,p1,p2).'
> 2. module records tp1, tp2, tp3, tp4, p1, p2 as well as the server's
> remote IP s1, s2, s3, s4 for future NAT'ing.
> 3. module alters the payload to '227 Entering Passive Mode
> (s1,s2,s3,s4,p1,p2).' and forwards packet to client.
> 4. module detects RELATED data channel being established.
> 5. module performs destination NAT to change packet destination from
> s1,s2,s3,s4 to tp1,tp2,tp3,tp4
> 6. module performs source NAT to change packet source from
> tp1,tp2,tp3,tp4 to s1,s2,s3,s4

 A transparent proxy is equivalent to a NAT module in all respects.=20
 Merely operates on the FTP layer in this case.
 Switch "module" for "proxy" and you have a good plan for fixing the=20
 bug.

 NOTE: If you do steps 5 and 6 in the IP layer you will be bypassing th=
e=20
 proxy data handling and void all your reasons for having it done by a=20
 proxy in the first place. Instead of by the conntrack NAT module for F=
TP=20
 for both outgoing and returning traffic.

>
> I've read over the netfilters hacking HowTo and some of the modules
> like ip_nat_ftp.c and ip_conntrack_ftp.c but I'm sure how to tie all
> these concepts together to develop my solution. I was wondering if=20
> any
> of the netfilter gurus could help point me in the right direction=20
> with
> an overall strategy of how to develop this solution.

 Disclaimer: I'm not one of the NF gurus. Just a proxy guy.

 AYJ
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
