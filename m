From: "David S. Miller" <davem@redhat.com>
Subject: Re: PROBLEM: 2.4.23-rc4 -> rc1 hang with change to ip_nat_core.c
 made in pre4
Date: Wed, 12 Nov 2003 19:59:08 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031112195908.0611fe2e.davem@redhat.com>
References: <200311121442.27406.beau@beaucox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Beau E. Cox" <beau@beaucox.com>
In-Reply-To: <200311121442.27406.beau@beaucox.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Marcelo has reverted the change in question, so his current
2.4.x tree should be fine.
