From: basteon <basteon@gmail.com>
Subject: question related rules editor iptc based
Date: Tue, 24 Nov 2009 21:17:38 +1000
Message-ID: <328fe7150911240317i5068de6ew8e5c57639478585@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:43628 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbZKXLRc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:17:32 -0500
Received: by iwn1 with SMTP id 1so402254iwn.33
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2009 03:17:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

struct ipt_entry *entry = NULL;
struct ipt_entry_target *pt = NULL,*ptl=NULL;
struct ipt_entry_match *pm=NULL,*pml=NULL;
struct ipt_udp *pudp=NULL;
struct ipt_icmp *picmp=NULL;
struct xt_length_info *payload = NULL;

#udp
match_size += sizeof(struct ipt_entry_match) + sizeof(struct ipt_udp);
size = sizeof(*entry) + match_size + target_size;
entry=calloc(1,size);
entry->target_offset=sizeof(*entry)+match_size;
entry->ip.proto = proto;
--------------------
and then trying enroll this rule.
pm=(struct ipt_entry_match*) entry->elems;
pm->u.user.match_size = match_size;
strcpy(pm->u.user.name,"udp");
pudp = (struct ipt_udp*) pm->data;
pudp->spts[0] = pudp->spts[1] = src_port;
pudp->dpts[0] = pudp->dpts[1] = dst_port;
pt = (struct ipt_entry_target*)(entry->elems+match_size);
pt->u.user.target_size = target_size;
# length
match_size = sizeof(struct xt_length_info);
--------------------
pml=(struct ipt_entry_match*) entry->elems;
pml->u.user.match_size = match_size;
strcpy(pml->u.user.name,"length");
payload = (struct xt_length_info*) pml->data;
payload->max = 10;
ptl = (struct ipt_entry_target*)(entry->elems+match_size);
ptl->u.user.target_size = target_size;


but, it just not happening, what's wrong? it well works with tcp and
icmp except udp and payload length
