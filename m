From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] ipt_MASQUERADE.c
Date: Thu, 23 Oct 2003 13:54:48 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031023044241.0B7572C090@lists.samba.org>
References: <Law12-F115umXCr68LT0001608b@hotmail.com>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?B?UGFibG8gQW5kculzIE1hcnRpa2lhbg==?= <pablomartikian@hotmail.com>
In-reply-to: Your message of "Mon, 20 Oct 2003 21:44:50 +0200."
             <Law12-F115umXCr68LT0001608b@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <Law12-F115umXCr68LT0001608b@hotmail.com> you write:
> Hi all,
> 
> Sorry if this subject does not concern you. Unfortunately in the 
> ipt_MASQUERADE.c file I couldn't find any email address.
> 
> The MASQUERADE feature is not working since several kernel versions. I gues 
> for over 4 months or something.
> 
> In the file ipt_MASQUERADE.c, in the function masquerade_check(...), the 
> second check (size) always fails, making it impossible to use masquerade, 
> making it impossible to share internet connection.
> 
> When I used the DEBUGP, the print says "24 != 20".

What version of the kernel are you running?  (uname -r)

What version of iptables are you running?

What patch-o-matic patches (if any) have you applied?

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
