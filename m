From: "Michael Lawson (mshindo)" <michael@sphinix.com>
Subject: Link problems with libxtables
Date: Fri, 22 May 2009 12:28:50 +1200
Message-ID: <c97a47b90905211728p68fdaf94jf0b7214c12271a57@mail.gmail.com>
References: <c97a47b90905211727h6841648fu83004ba81e5bf3eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:21699 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZEVA2t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 May 2009 20:28:49 -0400
Received: by rv-out-0506.google.com with SMTP id f9so472520rvb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 21 May 2009 17:28:50 -0700 (PDT)
In-Reply-To: <c97a47b90905211727h6841648fu83004ba81e5bf3eb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am having problems using a member function of libxtables:

g++ main.cpp Firewall.cpp Rule.cpp Match.cpp IP4Addr.cpp -lxtables -liptc
/tmp/cce5IKHM.o: In function `print_match(xt_entry_match const*,
ipt_ip const*, int)':
Firewall.cpp:(.text+0x326): undefined reference to
`xtables_find_match(char const*, xtables_tryload,
xtables_rule_match**)'
collect2: ld returned 1 exit status
make: *** [all] Error 1

I understand this is most likely a link problem, can someone point me
in the right direction ?

--
Michael Lawson
