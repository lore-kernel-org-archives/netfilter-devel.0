From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [patch] iptables -L --rules to print command line version of
	rules
Date: Mon, 12 May 2008 14:26:06 +0200
Message-ID: <1210595166.11742.54.camel@henriknordstrom.net>
References: <1210548143.23433.41.camel@henriknordstrom.net>
	 <alpine.LNX.1.10.0805121030040.25441@fbirervta.pbzchgretzou.qr>
	 <1210587701.11742.41.camel@henriknordstrom.net>
	 <alpine.LNX.1.10.0805121251270.25441@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:54429 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYELM0M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 08:26:12 -0400
In-Reply-To: <alpine.LNX.1.10.0805121251270.25441@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On m=C3=A5n, 2008-05-12 at 12:52 +0200, Jan Engelhardt wrote:
> On Monday 2008-05-12 12:21, Henrik Nordstrom wrote:
>=20
> >The other difference is that this gives "save" like capability to
> >iptables-restore when used in a pipe, makging iptables-restore a mor=
e
> >complete batch interface for talking to iptables which was the main
> >motivation behind this.
>=20
> Example please :)

as you know iptables-restore is basically just a batch wrapper around
iptables, so everything iptables can do you can also do with
iptables-restore.


% iptables-restore -n
*filter
--list INPUT --rules
[caller reads the output to figure out what to modify]
--insert OUTPUT 2 -d 1.2.3.4 -J REJECT
--insert INPUT 4 -s 1.2.3.4 -J DROP
[caller wants to verify the result before commit]
--list INPUT --rules
COMMIT

all in one single fetch/modify/upload operation.

Or with the new version I am just about to submit, implementing this as
a new --list-rules (-S) command: (just need to split out some other
cleanup first..)

% iptables-restore -n
*filter
--list-rules INPUT
--add INPUT -s 1.2.3.4 -J DROP
--list-rules INPUT
COMMIT


A new patch and a couple minor related ones coming shortly.

Regards
Henrik

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
