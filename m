From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH] SIP/SDP conntrack and NAT helper
Date: Thu, 12 May 2005 10:08:20 +0200
Message-ID: <20050512080820.GA19043@roonstrasse.net>
References: <1115493770.1949.9.camel@www.l-chr.com.ar>
	<20050508205821.GE393@oknodo.bof.de>
	<1115588688.2031.11.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
Content-Disposition: inline
In-Reply-To: <1115588688.2031.11.camel@www.l-chr.com.ar>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Christian,

good to see someone is working on the "other" VoIP protocol (I'm doing
H.323) - I just read your code. Although I havn't yet fully understood
everything, I have some advices for you:


* haystack should be const, too:

 static __inline__ char *ct_sip_search(const char *needle,
                                       char *haystack, 


* in digits_len, 'shift' is unused.

* parse_ipaddr(): don't cast (const char*) to (char*) - endp should be
  "const char**". same in epaddr_len.

* in ip_nat_sip.c, you should not parse the packet again - this has
  already been done in in_conntrack_sip.c. sip_help() should pass the
  offsets it found over to ip_nat_sip() - see the other conntrack
  helpers, they all have "unsigned int matchoff, unsigned int
  matchlen" as parameter

* never use "signed int" for lengths. Although it may be unlikely that
  'len' can overflow in digits_len(), it is a matter of good style not
  to use signed integers for this stuff. Yesterday, Paul Starzetz
  released an advisory for a local hole in the Linux kernel regarding
  signed integers. Last year, there were a bunch of vulnerabilities
  due to signed integers...

* I'm not sure, but I believe there is an off-by-one error in your
  code, regarding the 'limit' parameter: in ct_sip_get_info you set
  'limit' to 'dptr + (dlen - hnfo->lnlen)', i.e. *limit is an invalid
  dereference. In contrast to this, in the called functions, you
  compare 'dptr <= limit'.

* again, I'm not sure: in ct_sip_get_info(), you use strncmp() to work
  with dptr, implying that dptr is a null-terminated string. You
  should check the length of dptr, not that of hnfo->lname, which _is_
  a null terminated string. I believe, hnfo->lnlen and hnfo->snlen are
  superfluous for this reason.

* code style: you should correct the indent in parameter lists:

  static int sip_help(struct sk_buff **pskb,
                             struct ip_conntrack *ct,

  change to:

  static int sip_help(struct sk_buff **pskb,
                      struct ip_conntrack *ct,


  code style again:

  if (ip_nat_sip_hook) {
      if (!ip_nat_sip_hook(pskb, ctinfo, ct, &dptr)) {
          /* ... */
      }
  }

  to:

  if (ip_nat_sip_hook &&
      !ip_nat_sip_hook(pskb, ctinfo, ct, &dptr)) {
      /* ... */
  }


Max
