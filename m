From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] sparc64 compatibility netfilter patches
Date: Wed, 01 Jan 2003 22:22:23 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030101.222223.122334112.davem@redhat.com>
References: <20030101171654.B25870@linux.karinthy.hu>
	<20030101213205.A27131@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: valko@linux.karinthy.hu
In-Reply-To: <20030101213205.A27131@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


The hack for building the tools is wrong, there are 64-bit
compilers and userspace available.

The real fix for that (for when your tools are 32-bit) is
to run "sparc32 /bin/sh" and compile in that environment.

I'll be looking at the kernel side patch next, it should be
ok.
