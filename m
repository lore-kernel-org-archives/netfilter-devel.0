From: Patrick Schaaf <bof@bof.de>
Subject: Re: Brute force printk routines for looking at netfilter structures
Date: Tue, 17 Dec 2002 21:37:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021217203737.GA25448@oknodo.bof.de>
References: <000001c2a609$30f256e0$0100a8c0@zultys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ranjeet Shetye <ranjeet.shetye@zultys.com>
Content-Disposition: inline
In-Reply-To: <000001c2a609$30f256e0$0100a8c0@zultys.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello "Kernel Professor" :-)

some quick and dirty comments, after cursory reading of nf_debug.c:

> signed int nf_debug_indent = 0;

Why signed? Anyway, this will fall on its face on SMP systems.
Cure: use atomic_t.

I bet you can speed up your NF_DPF macro a lot. Try this:

#define NF_DPF(format, args...) \
{ \
	printk( \
		"%s() at %s:%d " \
		"%.*s" \
		format , \
		__FUNCTION__, __FILE__, __LINE__, \
		nf_debug_indent, "\t", \
		##args ); \
}

(Lightly tested; note that with that macro 'format' has to be
a string constant)

best regards
  Patrick
