From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
 infrastrure for netfilter]
Date: Fri, 14 Jan 2005 19:02:54 +0100
Message-ID: <41E8094E.9070508@trash.net>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
	<1105686102.7311.101.camel@localhost.localdomain>
	<20050114083731.GI9070@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>, Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050114083731.GI9070@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>>Does that mean I should *not* send the expectation and NAT patches to
>>DaveM now?  (Posted before the ct_extend patches):
>>
>
>I was wondering all the time why we keep talking about maintainance mode
>for ip_conntrack and the coincidential spike in new development for
>ip_conntrack.
>
>I think if we push it into ip_conntrack, we need to make sure
>nf_conntrack is in sync at the same time - otherwise poor Yasuyuki has
>to (again) sync all the changes... I think he did that often enough...
>
I'm willing to take care of this after Rusty's patches are in.

Regards
Patrick
