From: Nadeem Douba <ndouba@gmail.com>
Subject: FTP Packet Mangling & NAT
Date: Wed, 8 Jun 2011 16:18:11 -0400
Message-ID: <BANLkTintTA8T_FEqF-vWe85iTonfZHGn3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47585 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1FHUSM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:18:12 -0400
Received: by pvg12 with SMTP id 12so411621pvg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 13:18:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I have an interesting scenario where I have a transparent proxy that
does some funny things with PASSIVE=A0FTP communications that is making
me think of developing a netfilters module to correct the behavior.
What is going on is the following:

1. Client establishes connection to FTP server s1.s2.s3.s4 via
transparent proxy (where s1, s2, s3, s4 is the first, second, third,
and fourth octet of the IPv4 address for the remote server,
respectively)
2. Client sends PASV command to FTP server indicating that the client
will be using a PASSIVE FTP connection for its data channel
3. Server responds with '227 Entering Passive Mode
(tp1,tp2,tp3,tp4,p1,p2).' (where t1, t2, t3, t4 is the first, second,
third, and fourth octet of the IPv4 address for the transparent proxy,
respectively. Where p1 and p2 are the higher and lower order octets
for the remote TCP port, respectively)

In step three, the transparent proxy modifies the server's original
response to the PASV command by translating what should have been '227
Entering Passive Mode (s1,s2,s3,s4,p1,p2).' to '227 Entering Passive
Mode (tp1,tp2,tp3,tp4,p1,p2).'. Some clients (like IE and Firefox)
don't like this at all and this results in a broken FTP session.

This is where a custom netfilters module would come in handy. I'd like
to be able to "untranslate" the server's response back into it's
original form. However, the transparent proxy expects to broker the
passive data channel at the same time, so simply fixing the response
would break the communications to and from the FTP server. Therefore,
in addition to fixing the server's response, I need to do some NAT'ing
on all data channel packets. I was wondering if anybody could help
point me in the right direction with regards to developing such a
module. The flow would be as follows:

1. module detects PASV response '227 Entering Passive Mode
(tp1,tp2,tp3,tp4,p1,p2).'
2. module records tp1, tp2, tp3, tp4, p1, p2 as well as the server's
remote IP s1, s2, s3, s4 for future NAT'ing.
3. module alters the payload to '227 Entering Passive Mode
(s1,s2,s3,s4,p1,p2).' and forwards packet to client.
4. module detects RELATED data channel being established.
5. module performs destination NAT to change packet destination from
s1,s2,s3,s4 to tp1,tp2,tp3,tp4
6. module performs source NAT to change packet source from
tp1,tp2,tp3,tp4 to s1,s2,s3,s4

I've read over the netfilters hacking HowTo and some of the modules
like ip_nat_ftp.c and ip_conntrack_ftp.c but I'm sure how to tie all
these concepts together to develop my solution. I was wondering if any
of the netfilter gurus could help point me in the right direction with
an overall strategy of how to develop this solution.

Your help would be greatly appreciated!

Thanks,

Nadeem
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
