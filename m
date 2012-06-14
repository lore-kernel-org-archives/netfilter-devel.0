From: Deepak Jangid <deepak_jangid1987@yahoo.co.in>
Subject: Regarding connection mappings to module data structures
Date: Thu, 14 Jun 2012 14:18:33 +0800 (SGT)
Message-ID: <1339654713.58676.YahooMailNeo@web193406.mail.sg3.yahoo.com>
Reply-To: Deepak Jangid <deepak_jangid1987@yahoo.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm19-vm8.bullet.mail.sg3.yahoo.com ([106.10.149.119]:28887 "HELO
	nm19-vm8.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752015Ab2FNGSf convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 02:18:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Netfilter team,
=A0
I am seeking an infrastructure for mapping
conntrack(struct nf_conn) to a module private data structure as a conte=
xt for
every connection.
I could not find any such.
=A0
I can add the private info when I see a new connection.
conntrack destroy events can be caught to destroy the
private structure.
But the thing is there is no mechanism to store the
private info mapped to a connection. Either I will have to maintain
hash-tables, which is highly irrelevant, or edit the nf_conn which seem=
s a
better way.
=A0
What I was thinking is to have a list_head or a pointer
to a structure in nf_conn which can handle such scenarios.
=A0
Does this seems generic ? Well yes there is
conntrack_extend, but it is not generic to be usable by other modules.
=A0
Best Regards,
Deepak Jangid
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
