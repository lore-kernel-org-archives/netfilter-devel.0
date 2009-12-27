From: Roman Tsisyk <roman@tsisyk.com>
Subject: Re: Bypass rules using conntrack helpers
Date: Sun, 27 Dec 2009 21:12:56 +0600
Message-ID: <faefb3f10912270712w35657bc4s6bd037e899211010@mail.gmail.com>
References: <faefb3f10912270011l48b955cejbbafc3f8a6e55c97@mail.gmail.com>
	 <alpine.LSU.2.01.0912271303490.6911@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:46435 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZL0PM4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Dec 2009 10:12:56 -0500
Received: by iwn1 with SMTP id 1so6885223iwn.33
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Dec 2009 07:12:56 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.0912271303490.6911@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 27, 2009 at 6:16 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>
> On Sunday 2009-12-27 09:11, =D0=A0=D0=BE=D0=BC=D0=B0=D0=BD =D0=A6=D0=B8=
=D1=81=D1=8B=D0=BA wrote:
>>
>>=D0=90 questionable point exists in the conntrack expectations design=
=2E What
>>happens if somebody opened fake outgoing connection which would match
>>conntrack helpers' signatures? Conntrack module will be able to add
>>records in expectation table.
>>Unfortunately, all users from 192.168.0.0/24 will have problems with
>>an active FTP. Users will force administrators to read boring manuals
>>as alredy founded and load nf_connrack_ftp + nf_nat_ftp to "overcome"
>>the problem.
>>Next, if malicious software would initiate connection as in the
>>previous case, NAT subsystem will forward (y << 8 | z) port to outsid=
e
>>by changing source PORT command and, in fact, forwarding a port
>>inside. So, if we something would open connections to remote 21 port
>>and send our PORT commands, we can transparently open ANY port from
>>INTERNAL server to the public Internet, regardless NAT. Hereinafter,
>>I'll call this "conntrack back-connection issue".
>
> That is what helpers are supposed to do. If that poses a security ris=
k,
> to your network, I advise not to use them. In case of FTP that is eas=
ily
> worked around by using passive ftp.
>
> Furthermore, the problems NAT brings with itself (ETE connectivity is
> just one) are well-known. Getting your own IPv6 tunnel is a
> no-brainer these days.
>
>>Furthermore, various ways to inititate connections from client exists=
=2E
>>It can be malicious software, that needs only user permisions to open
>>connection outgoing connection, or user himself, or ... surprise, jus=
t
>>a web-browser.
>
> That is why, as far as I gather, security standards advise to use
> proxies for the connections from the internal network to the
> Internet.
>

Of course, various solution exists, as you already pointed out a
passive FTP and a directly connection using IPv4 or IPv6.
However, NAT is still being widely used today. Sometimes this scheme
includes transparent squid with REDIRECT rule. Moreover, I noticed
that other helpers also can create problems like these, not just ftp
helper. Not everyone will think how helpers works, so a lot of manual
errors and buggy configurations exists.

=46or first case we can avoid problem by changing
net.ipv4.ip_local_port_range and specifying  only these values in
--dport at the "-m state --state" rule.
=46or second case, we can play with FORWARD chain rules and make its
conntrack-based (and specify --dport for tcp / udp).
We can simple unload conntrack_ftp too.

BTW, I've never seen such settings in small, especially in the box
Linux routers (e.g. Linksys, D-link, etc.), but ip/nf_conntrack_ftp
was loaded or built-in. I've just asked friend of mine to connect
remote ftp through a particular 2.4.x ADSL router with probably loaded
ip_conntrack_ftp, and his records showed me, that active ftp worked
without any problems, lsmod was almost empty (i.e. modules really
built-in), but no appropriate rules existed in iptables.

PS: it seems that Dan Carpenter has founded another problem with the mo=
dule
--=20
WBR, Tsisyk Roman
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
