From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT
Date: Sun, 21 Sep 2003 18:16:11 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921181611.4e48af79.davem@redhat.com>
References: <20030921144013.GA22223@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030921144013.GA22223@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 21 Sep 2003 16:40:13 +0200
Harald Welte <laforge@netfilter.org> wrote:

> Some people use REJECT in the OUTPUT chain (rejecting locally generated
> packets).  This didn't work anymore starting with some fixes we did in 2.4.22. 
> A dst_entry for a local source doesn't contain pmtu information - and
> thus the newly-created packet would instantly be dropped again.

Applied to 2.4.x, thanks Harald.
