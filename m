From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6+2.4] fix DEBUG compile in ipt_MASQUERADE
Date: Mon, 29 Mar 2004 20:21:50 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329202150.667fbe16.davem@redhat.com>
References: <20040329104437.GF1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040329104437.GF1528@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 29 Mar 2004 12:44:37 +0200
Harald Welte <laforge@netfilter.org> wrote:

> This is a bugfix to ipt_MASQUERADE.c to make it compile when debugging
> is switched on.  The patch applies cleanly to 2.4.x and 2.6.x.

Applied, thanks Harald.
