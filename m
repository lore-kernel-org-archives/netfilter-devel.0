From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] netfilter: don't flush MASQ if IP didn't change
Date: Tue, 2 Dec 2003 01:28:13 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031202012813.6a92b158.davem@redhat.com>
References: <20031130124145.GC26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031130124145.GC26749@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 30 Nov 2003 18:11:45 +0530
Harald Welte <laforge@netfilter.org> wrote:

> Author: Rusty Russell <rusty@rustcorp.com.au>
> Status: Testing, already submitted to 2.6
> 
> Herve Eychenne noted that many ADSL connections get the same
> address when the interface comes back up, so some users use SNAT
> instead of masquerade.  The answer is that MASQUERADE should only
> drop connections when the interface comes up, and then only if the
> interface address has actually changed.

Applied, thanks.
