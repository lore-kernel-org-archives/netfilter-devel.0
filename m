From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4.23] pending ip_queue_maxlen fix
Date: Tue, 2 Dec 2003 00:14:23 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031202001423.48cb8510.davem@redhat.com>
References: <20031130121650.GC1506@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031130121650.GC1506@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 30 Nov 2003 17:46:50 +0530
Harald Welte <laforge@netfilter.org> wrote:

> Somehow the attached fix didn't make it into 2.4.23.  I thought I had
> submitted this before, but I must have be mistaken.  Anyway, please make sure
> this included in 2.4.24.

It was not an OOPS or security fix, therefore I queued it into
my 2.4.24-pre1 pending tree, which I just asked Marcelo to
pull from.
