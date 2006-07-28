From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: problems with conntrackd-0.8.2 and 0.8.1
Date: Fri, 28 Jul 2006 16:54:28 +0200
Message-ID: <44CA2524.2040008@netfilter.org>
References: <44C619D3.5040306@netfilter.org> <44C646C7.2030704@ufomechanic.net>
	<44C66068.6020000@netfilter.org> <44C790BD.3090207@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C790BD.3090207@ufomechanic.net>
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

Amin Azez wrote:
> I'm trying out the new ctnetlink with conntrackd-0.8.2
> 
> I've got the latest libnfnetlink and libnetfilter_conntrack from svn,
> but conntrackd-0.8.2 and 0.8.1 give this error:
> /opt/KERNEL/conntrackd/conntrackd-0.8.2/src/events.c:67: undefined
> reference to `nfct_conntrack_is_snatted'
> events.o(.text+0x260):/opt/KERNEL/conntrackd/conntrackd-0.8.2/src/events.c:58:
> undefined reference to `nfct_conntrack_is_dnatted'
> 
> and loads more.
 >
> I can't find reference to nfct_conntrack_is_snatted anywhere in any of
> my source trees, even google and gmane have nothing to say.
 >
> nm -as /usr/local/lib/libnetfilter_conntrack.a doesn't find the symbol
> either, or any symbol with "snat" within it.
> 
> Is there a file missing from conntrackd?

No, probably you forgot to apply the patches included in the directory 
"patches" inside conntrackd-0.8.2 that provides those functions.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
