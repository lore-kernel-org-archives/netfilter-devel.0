From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables compat code error way & module refcounting fix
Date: Mon, 30 Oct 2006 17:04:43 +0100
Message-ID: <4546229B.8050808@trash.net>
References: <200610301331.32650.dim@openvz.org> <45461E0F.6010504@trash.net>
	<200610301857.35697.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Kirill Korotaev <dev@openvz.org>, netfilter-devel@lists.netfilter.org,
	Vasily Averin <vvs@openvz.org>, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200610301857.35697.dim@openvz.org>
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

Dmitry Mishin wrote:
> On Monday 30 October 2006 18:45, Patrick McHardy wrote:
> 
>>This doesn't look right, if we fail at xt_alloc_table_info for
>>example the module references are not released.
> 
> module references will be released because of 'goto out;' line just after 
> xt_compat_unlock() - it is missed because of standard +-3 lines patch 
> context, sorry.

You're right, I misread the code. Applied, thanks.
