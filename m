From: =?iso-8859-1?q?Alberto=20D=EDez?= <albertowhiterabbit@yahoo.es>
Subject: optimizations for large rule sets
Date: Wed, 5 Mar 2008 16:45:55 +0100 (CET)
Message-ID: <727356.70580.qm@web26503.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web26503.mail.ukl.yahoo.com ([217.146.176.40]:22352 "HELO
	web26503.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753335AbYCEPwi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:52:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi!

I am trying to make use of a large number of rules
with iptables.=20

I have seen there are some optimizations referenced
like nf-HiPAC (www.hipac.org) , iptables with
classifiers (www.geocities.com/hamidreza_jm) which
appearently can deal with thousands of rules (thats
what i need).

I want per flow (orig addr,dst addr, orig port, dst
port, proto) filtering thats why i don=B4t think i can
use ipsets (or can i?)
I also would like to have the nice iptables features
like  mangle table and counters ..

I dont really understand what the conntrack does, or
if it can somehow helpme (where is the nice
documentation about this??)

What is the netfilter preferred way to have a large
set of rules and still do packet filtering?  are
HiPAC, iptables with classifiers or any other solution
actual?

is there a howto,wiki,manual,some kind of
documentation, all that I find about this are quite
old (3 years?) material in the mailing list ... Is
this problem already solved? what was the solution
taken?


well if you could answer any of this questions i would
be very thankful

Alberto Diez


      =20
______________________________________________=20
=BFCon Mascota por primera vez? S=E9 un mejor Amigo. Entra en Yahoo! Re=
spuestas http://es.answers.yahoo.com/info/welcome
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
