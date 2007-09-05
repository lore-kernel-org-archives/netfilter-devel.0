From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH 2/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
Date: Wed, 05 Sep 2007 16:26:39 -0400
Message-ID: <1189023999.12261.147.camel@jcmlaptop>
References: <20070904203053.GC19083@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, adam@yggdrasil.com, jcm@jonmasters.org,
	kaber@trash.net, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757298AbXIEU2d@vger.kernel.org>
In-Reply-To: <20070904203053.GC19083@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2007-09-04 at 16:30 -0400, Neil Horman wrote:

> 	2nd of two patches.  This patch enhances modprobe to operate like rmmod
> in non-blocking mode.  It also adds a -w option to allow for explicit blocking
> operation.

As I suspected, this patch isn't in the tree. I am going to commit it
now because it makes sense. I'm also going to sort out moving things to
kernel.org this afternoon while I'm at it - I don't want to confuse
people with kerneltools.org any more now I've got a kernel.org acc.

Jon.
