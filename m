From: "David S. Miller" <davem@redhat.com>
Subject: Re: iptables+2.6-test8-bk4 : Still problems
Date: Sun, 26 Oct 2003 22:34:38 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031026223438.1cf757ce.davem@redhat.com>
References: <3F9B8A5D.9010803@triaton-webhosting.com>
	<200310261052.25944.rezso@rdsor.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: georg.chini@triaton-webhosting.com, sparclinux@vger.kernel.org,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balint Cristian <rezso@rdsor.ro>
In-Reply-To: <200310261052.25944.rezso@rdsor.ro>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


It's some bug in the translation code in net/compat.c

If someone could review that code and try to find the bug
I'd appreciate it as I have a million other things to do
over the next few days.

Thanks.
