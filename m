From: Michael Griego <mgriego@nearband.com>
Subject: conntrackd IPv6 client support for interface scope
Date: Wed, 7 May 2014 15:18:04 -0500
Message-ID: <C1308655-F367-4C0F-BD8D-DF62B0E7A8EA@nearband.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zcs-mta-01.nearband.com ([206.123.92.78]:38975 "EHLO
	zcs-mta-01.nearband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGUZh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2014 16:25:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by zcs-mta-01.nearband.com (Postfix) with ESMTP id 2217B60115
	for <netfilter-devel@vger.kernel.org>; Wed,  7 May 2014 15:18:21 -0500 (CDT)
Received: from zcs-mta-01.nearband.com ([127.0.0.1])
	by localhost (zcs-mta-01.nearband.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ilQOrsbMsacU for <netfilter-devel@vger.kernel.org>;
	Wed,  7 May 2014 15:18:12 -0500 (CDT)
Received: from michaeliegosmbp.nearband.private (static-71-244-49-21.dllstx.fios.verizon.net [71.244.49.21])
	by zcs-mta-01.nearband.com (Postfix) with ESMTPSA id 634206018B
	for <netfilter-devel@vger.kernel.org>; Wed,  7 May 2014 15:18:12 -0500 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greetings,

I=92ve been setting up conntrackd on a pair of new firewalls, and I dis=
covered that, while the server code handles setting the scope for the I=
Pv6 address structure, the client code does not.  In a case where a per=
son is using link-local addresses for conntrackd syncing (as I am) on a=
 multi-homed system (as is generally expected in these scenarios, espec=
ially since conntrackd is expected to be running on a dedicated interfa=
ce), this causes the server socket to get bound to the proper scope/int=
erface, but the client socket never gets the scope, so it will fall bac=
k to the kernel routing table to connect to its peer.  The kernel routi=
ng table will often not choose the correct interface for this.

I patched my local copy of conntrack-tools (for UDP in this case) as so=
:

--- conntrack-tools-1.4.1.orig/src/udp.c	2013-02-24 16:23:57.183985009 =
-0600
+++ conntrack-tools-1.4.1/src/udp.c	2014-05-07 14:18:20.407835364 -0500
@@ -144,6 +144,7 @@
 		memcpy(&m->addr.ipv6.sin6_addr, &conf->client.inet_addr6,
 		       sizeof(struct in6_addr));
 		m->sockaddr_len =3D sizeof(struct sockaddr_in6);=20
+		m->addr.ipv6.sin6_scope_id =3D conf->server.ipv6.scope_id;
 		break;
 	default:
 		ret =3D -1;


It simply sets the scope ID of the client socket to the same one that=92=
s being used for the server socket.  It should be a safe assumption, si=
nce only one Interface stanza is used for the channel configuration.  T=
his did allow usage of link-local addresses to begin working properly w=
ithout having to resort to setting up host routes in each firewall for =
the link local address of each other.

The same thing would need to be done for the other channel types as wel=
l, but I was curious about the reception of this type of patch before c=
reating a full patch (against 1.4.2 instead of 1.4.1, of course).  As I=
 said, this patched code is now working properly in my setup using link=
-local IPv6 addresses in a UDP unicast channel.

--Mike

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
