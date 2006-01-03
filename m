From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for H323 connection tracking for kernel 2.6.14 and Panic
 with SIP tracking
Date: Tue, 03 Jan 2006 12:30:38 +0100
Message-ID: <43BA605E.3020801@trash.net>
References: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>
	<c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Moises Silva <moises.silva@gmail.com>
In-Reply-To: <c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>
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

Moises Silva wrote:
> still getting kernel panic, copy the whole thing is a time consuming
> task, for now doing nothing, but i have downgraded the kernel to
> 2.6.13 and at least it does not kernel panics. Some one has a patch
> for sip connection tracking for kernel-2.6.14??

Most likely you need to change

         ip_ct_refresh_acct(ct, ctinfo, NULL, sip_timeout * HZ);

to

         ip_ct_refresh(ct, *pskb, sip_timeout * HZ);

in net/ipv4/netfilter/ip_conntrack_sip.c. If that doesn't help
please post the entire oops.
