From: "Beau E. Cox" <beau@beaucox.com>
Subject: Re: PROBLEM: 2.4.23-rc4 -> rc1 hang with change to ip_nat_core.c made in pre4
Date: Wed, 19 Nov 2003 05:55:22 -1000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200311190555.22438.beau@beaucox.com>
References: <200311121442.27406.beau@beaucox.com> <20031112195908.0611fe2e.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20031112195908.0611fe2e.davem@redhat.com>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 12 November 2003 05:59 pm, David S. Miller wrote:
> Marcelo has reverted the change in question, so his current
> 2.4.x tree should be fine.

Thank you all for reverting the pre4 change to ip_nat_core.c that
was giving me problems.

I have 2.4.23-rc2 up and running fine.

Aloha => Beau;
