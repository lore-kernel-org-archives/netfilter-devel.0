From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: Re: [PATCH] ip_nat_sip: fix compiler warning
Date: Sun, 28 May 2006 17:32:25 +0200
Message-ID: <1148830346.32002.9.camel@scaramouche.combox.de>
References: <1148823979.32002.2.camel@scaramouche.combox.de>
	<4479B3C4.1040404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4479B3C4.1040404@trash.net>
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

On So, 2006-05-28 at 16:29 +0200, Patrick McHardy wrote:
> Torsten Luettgert wrote:
> > 
> Thanks, but the SIP helper in patch-o-matic is quite out of date.
> I have a version with that warning (and some other things) already
> fixed queued for upstream submission. After that I'll most likely
> remove it from pom.

Ok, I'll just switch if off in my 2.6.16 kernels.

BTW: What about the new protoff argument to match functions, and
the change from struct ipt_ip * to void * in the checkentry
functions (e.g. in the set match).

Are those already fixed and going upstream, too, or would it be
worthwile to submit patches for old matches and targets?

Regards,
Torsten
