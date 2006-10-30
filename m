From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add missing unlock in get_next_corpse()
Date: Mon, 30 Oct 2006 16:31:51 +0100
Message-ID: <45461AE7.6070806@trash.net>
References: <1162124840.29771.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1162124840.29771.2.camel@localhost.localdomain>
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

Martin Josefsson wrote:
> Add missing unlock in get_next_corpse() in nf_conntrack. It was missed during
> the removal of listhelp.h . Also remove an unneeded use of
> nf_ct_tuplehash_to_ctrack() in the same function.
> 
> Should be applied before 2.6.19 is released.

Applied, thanks for catching this.
