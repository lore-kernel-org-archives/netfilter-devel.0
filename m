From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] NETFILTER: ipt_ULOG fix for last packet delay
Date: Sun, 1 Aug 2004 19:40:29 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801194029.62162fbc.davem@redhat.com>
References: <20040801212705.GA18758@sunbeam2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040801212705.GA18758@sunbeam2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 1 Aug 2004 23:27:05 +0200
Harald Welte <laforge@netfilter.org> wrote:

> The ULOG target used to delay the last packet until another one was received.
> This patch fixes the issue.

Applied.
