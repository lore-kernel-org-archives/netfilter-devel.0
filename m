From: "Narendra Prabhu. B" <naren@deeproot.co.in>
Subject: Is libiptc responsible for any memory leak?
Date: Tue, 7 Jan 2003 12:10:39 +0530 (IST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.43.0301071139010.282-100000@abodh.pesit.deeproot.co.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: leonardo@opalsoft.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

Few days back I had posted, regarding memory leakage in the libiptc
APIs.

I worked more closely with libiptc and some debuggers(ccmalloc ,valgrind).
Now I able able to, precisly point out functions(APIs) were responsible
for memory leakage:-

1> iptc_init(..)
	there is some memory leakage here... but if we mention that
free(the_handle), there is no memory leakage from here.. This is not done
in iptables-save.c function "static int do_output(const char *tablename);
" seems like the free(h) was commented out. ref: iptables-1.2.7a

2> iptc_first_chain(..)
	here to there is some memory leakage.


Are the developers aware of this?
Hope we get some response.


Regards,
Narendra.

In the middle of difficulty..... lies Opportunity. (Albert Einstein)
--------------------------------------------------------------------
Narendra Prabhu. B             Free Software at its product-ive best.
DeepRoot Linux                             http://www.deeproot.co.in
                ---- Server Appliances ----
             ---- Linux Support and Services ----
-------------------------------------------------------------------
