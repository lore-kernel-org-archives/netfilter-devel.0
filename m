From: "David S. Miller" <davem@redhat.com>
Subject: Re: iptables+2.6-test8-bk4 : Still problems
Date: Tue, 28 Oct 2003 22:48:03 -0800
Sender: sparclinux-owner@vger.kernel.org
Message-ID: <20031028224803.1d16aa9c.davem@redhat.com>
References: <3F9B8A5D.9010803@triaton-webhosting.com>
	<200310261052.25944.rezso@rdsor.ro>
	<20031026223438.1cf757ce.davem@redhat.com>
	<3F9ED206.4040806@triaton-webhosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: rezso@rdsor.ro, sparclinux@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
Return-path: <sparclinux-owner@vger.kernel.org>
To: Georg Chini <georg.chini@triaton-webhosting.com>
In-Reply-To: <3F9ED206.4040806@triaton-webhosting.com>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Oct 2003 21:31:02 +0100
Georg Chini <georg.chini@triaton-webhosting.com> wrote:

> David S. Miller wrote:
> > It's some bug in the translation code in net/compat.c
> 
> Yes it is.
> The problem is, that the ipt_entries are not all the same
> size. So instead of copying them one by one you have
> to copy the whole block. Here is a patch:

Good spotting, I didn't know this.

However, I was trying to avoid a kmalloc of anything in this code :(
You're also not verifying the kmalloc() return value for errors.

I think I'll use copy_in_user() to fix this bug, thanks.
