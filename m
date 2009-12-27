From: =?UTF-8?B?0KDQvtC80LDQvSDQptC40YHRi9C6?= <roman@tsisyk.com>
Subject: Bypass rules using conntrack helpers
Date: Sun, 27 Dec 2009 14:11:06 +0600
Message-ID: <faefb3f10912270011l48b955cejbbafc3f8a6e55c97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:54533 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZL0ILI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Dec 2009 03:11:08 -0500
Received: by iwn1 with SMTP id 1so6805989iwn.33
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Dec 2009 00:11:07 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear, Netfilter developers!

Recently, I wondered how conntrack's helpers work.

=E1 questionable point exists in the conntrack expectations design. Wha=
t
happens if somebody opened fake outgoing connection which would match
conntrack helpers' signatures? Conntrack module will be able to add
records in expectation table. And somebody would connect to this port
from outside and come through iptables rules.

If you think that this is just a joke, I intend to show that it is a
really serious problem and I founded two ways to exploit it.

In the first case, we have a single Linux host connected directly to
the public network.
Usually, iptables config for the workstation are similar to this:
------
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT #
accept established connections
iptables -A INPUT -p tcp --dport 80 -j ACCEPT # allow access to http se=
rver
iptables -P INPUT DROP # drop other incoming connections

iptables -P OUTPUT -j ACCEPT # allow any connection from the host
------
Also nf_conntrack_ftp module loaded in order to enable active ftp
work. You can argue that this configuration so stupid, and I must
specify --dport in -m state rule. I understand, but anyway, I found
plenty of manuals on the Internet which look like above described,
e.g. https://help.ubuntu.com/community/IptablesHowTo

If malicious software could initiate connection to remote 21 port and
send tcp packets like this
------
> USER anonymous
> PASS test@example.com
> PORT x,x,x,x,y,z
------
where x,x,x,x is host ip on external network, then (y << 8 | z) port
will be OPENED from the sender ip address.
=46or example, we can use y=3D0, z=3D22 to open a ssh port, or, y=3D21,=
 z=3D56
to open a database server.

In the second case, we have host in local network masquared by Linux NA=
T.
Regular iptables config for NAT looks like this:
------
iptables -A FORWARD -s 192.168.0.0/24 -o eth1 -j ACCEPT
iptables -A FORWARD -d 192.168.0.0/24 -i eth1 -j ACCEPT
iptables -P FORWARD DROP

iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth1 -j SNAT
--to-source x.x.x.x
sysctl -w net.ipv4.conf.all.forwarding=3D1
------
where 192.168.0.0/24 internal network and x.x.x.x external ip address.

Unfortunately, all users from 192.168.0.0/24 will have problems with
an active FTP. Users will force administrators to read boring manuals
as alredy founded and load nf_connrack_ftp + nf_nat_ftp to "overcome"
the problem.

Next, if malicious software would initiate connection as in the
previous case, NAT subsystem will forward (y << 8 | z) port to outside
by changing source PORT command and, in fact, forwarding a port
inside. So, if we something would open connections to remote 21 port
and send our PORT commands, we can transparently open ANY port from
INTERNAL server to the public Internet, regardless NAT. Hereinafter,
I'll call this "conntrack back-connection issue".

=46urthermore, various ways to inititate connections from client exists=
=2E
It can be malicious software, that needs only user permisions to open
connection outgoing connection, or user himself, or ... surprise, just
a web-browser.
Contemporary HTML standards support for outgoing socket connections in
web applications. Moreover, now you can use Adobe Flash, Java Applets,
XMLHTTPRequest and so on to start an outgoing connection and to send
appropriate signatures through conntrack helpers.

I have made simple exploit of this issue. This is just a simple HTML
page on client and fake FTP server on the side of attacker. Currently,
no browsers in production supported WebSockets and I decided to use
flash-based jSocket library to initiate back-connections.

A small protection exists in nf_conntrack_ftp code. It checks if ip
address in PORT command exactly same as a sender ip address. So, we
can't get internal client ip address in a browser, it's absolutely
impossible. If you knew how to do it, please tell me. So my code
blindly probes all fake ip addresses. It transmits about 3-4 megabytes
for /16 network (its just nothing for contemporary speeds).

I have published all at a my git repo
(http://gitorious.org/art1x/conntrack-issue). I tested this code with
various versions of kernel, incl. 2.4.x and current 2.6.x. A lot of
network devices loads nf_conntrack_* modules by default, because users
have problems with old protocols such as active ftp. I think, usually
administrators of various corporate' routers also enables it.

All that I have described above are not bug, it just ftp protocol
design drawbacks.
=46TP is a application level protocol (in terms of OSI model) that send=
s
information about level 3 connection (ip address in PORT command).
BTW, a file transfer protocol was invented in the 70s before any
established network models. There are a lot of application level
protocols which also have some problems and can't be transparently
transfered over the NAT without additional efforts, e.g. sip, p2p,
etc. But anyway, only nf_conntrack_ftp adds tcp exceptions to
Netfilter, and udp proto isn't really interested.

Code of nf_conntrack_ftp.c is perfect and I've no idea what we can
additionaly check here. Somebody also uses other helpers, not only the
nf_conntrack_ftp. This modules is really needed for normal work, but
its unsecury at the sometime. May be, we should add a large warning
message to it? I've blacklisted application layer helpers at my
router, but I haven't found real solution of the problem yet.

--=20
WBR, Tsisyk Roman
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
