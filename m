From: Eric Leblond <eric@inl.fr>
Subject: Re: ip_queue_vwmark for pom-ng
Date: Mon, 14 Jun 2004 01:29:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087169398.12611.44.camel@coati>
References: <1086903111.4794.4.camel@coati>  <1087157463.11287.20.camel@ws>
	 <1087160421.3320.5.camel@coati>  <40CCC974.9080807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40CCC974.9080807@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2004-06-13 at 23:39, Patrick McHardy wrote: 
> Eric Leblond wrote:
> > On Sun, 2004-06-13 at 22:11, Patrick McHardy wrote:
> > 
> why didn't you just
> add the mark to ipq_verdict_msg instead of duplicating it and adding
> ipq_set_vwmark, which is 99% equal to ipq_set_verdict?

It's clearky the way to do. At the time I wrote the patch (last year), I
did'nt know it will break compatibility by changing libipq structure, so
I prefer to add another struct.

I resend a patch following your idea in the next days.

BR,
-- 
Eric Leblond <eric@inl.fr>
INL
