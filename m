From: Amin Azez <azez@ufomechanic.net>
Subject: problems with conntrackd-0.8.2 and 0.8.1
Date: Wed, 26 Jul 2006 16:56:45 +0100
Message-ID: <44C790BD.3090207@ufomechanic.net>
References: <44C619D3.5040306@netfilter.org> <44C646C7.2030704@ufomechanic.net>
	<44C66068.6020000@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <44C66068.6020000@netfilter.org>
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

I'm trying out the new ctnetlink with conntrackd-0.8.2

I've got the latest libnfnetlink and libnetfilter_conntrack from svn,
but conntrackd-0.8.2 and 0.8.1 give this error:
/opt/KERNEL/conntrackd/conntrackd-0.8.2/src/events.c:67: undefined
reference to `nfct_conntrack_is_snatted'
events.o(.text+0x260):/opt/KERNEL/conntrackd/conntrackd-0.8.2/src/events.c:58:
undefined reference to `nfct_conntrack_is_dnatted'

and loads more.

I can't find reference to nfct_conntrack_is_snatted anywhere in any of
my source trees, even google and gmane have nothing to say.

nm -as /usr/local/lib/libnetfilter_conntrack.a doesn't find the symbol
either, or any symbol with "snat" within it.

Is there a file missing from conntrackd?

Sam
