From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] fix ip_nat_ftp in 2.6.0-test1
Date: Thu, 17 Jul 2003 14:43:26 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030717144326.4f496995.davem@redhat.com>
References: <20030717211254.GA27685@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030717211254.GA27685@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 17 Jul 2003 23:12:54 +0200
Harald Welte <laforge@netfilter.org> wrote:

> This is a 2.6 only fix for the FTP NAT helper code.  The patch below
> (by Martin Josefsson) also closes Bug 933 in the kernel bug tracker.
> 
> The bug was introduced while making the helper compliant to the recently
> introduced support for nonlinear skb's in netfilter.

Applied, thanks Harald.
