From: =?ISO-8859-2?Q?=A3ukasz_Czy=BF?= <lukasz.czyzz@gmail.com>
Subject: NAT IPv6/IPv4 translator - request for review, plus two questions
 regarding code
Date: Thu, 15 Mar 2012 19:58:08 +0100
Message-ID: <CALJVcJFZ_qk_qdNFnfveQx+GJF3iXLmMBe=ezgphUiY2uiFpng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64321 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2COS6J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:58:09 -0400
Received: by vcqp1 with SMTP id p1so3465097vcq.19
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Mar 2012 11:58:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all

I have implemented IPv6/IPv4 NAT for Linux OS. It is written as kernel
module which registers its functions in netfilter hooks. I would like
some netfilter programming expert to review my code (it is first
kernel module written by me) and I am wondering what is the best form
of contributing source to make somebody willing to glance at it. I am
not sure if patch is the best way here, because I didn't make any
changes in any other netfilter-related code, just created new module
which only depends on netfilter hook register functions. Maybe tarball
with Makefile is enough?

Ttranslator is released under GPLv2 license - You can find more info
about it at <http://czyzu.pl/xlat.html>.


I would like to take occasion and ask two questions regarding my code here.

1. I have following structure defined:

/*
 * Helper struct used during packet translation
 */
struct xlat_translation_buffer {
    /* Following entries must not be splitted */
	struct iphdr		hdr4;
	struct icmphdr		i_hdr4;
    /* End of entries */

    /* Following entries must not be splitted */
	struct ipv6hdr		hdr6;
	union {
		struct frag_hdr		f_hdr;
		struct icmp6hdr		i_hdr6;
	} hdrs6;
    /* End of entries */

	u16			hdr_len;
	u16			hfrag_off;
	u16			frag;
	s16			hdr_diff;
	u16			payload_len;
};

As You can guess from comments, there are particular fields in that
structure which have to follow immediately, one after the other.
That's because sometimes they are copied at the same time, by using
one memcpy() call. Can I be sure that compiler won't put any void
bytes between them (for alignment purposes) on any platform? Or maybe
I should use substructures with 'packed' attribute to prevent such
situation?

2. Second question - I have already posted it on kernel-newbies
mailing list, but I am still not sure about it. Does every function
which is used during packet translation (so it may be called many
times every second) should be declared as inline? If no - what rules
should I follow when determining if function has to be inlined in
networking code.


Lukasz
