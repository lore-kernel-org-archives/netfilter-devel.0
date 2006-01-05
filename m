From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Linux 2.6 support for "rope" match module
Date: Thu, 5 Jan 2006 11:18:40 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0601051117590.21555@yvahk01.tjqt.qr>
References: <43BA5CCB.6050207@lowth.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Chris Lowth <chris@lowth.com>
In-Reply-To: <43BA5CCB.6050207@lowth.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Please feel free to download, play, comment / critique.
>
> "rope" provides a kernel-level interpreter for a simple scripting language
> which can be used to develop netfilter match modules. The language is
> pre-compiled using a perl script, to produce a binary file that is loaded into
> the kernel using the "iptables" command. The language has access to many IP,
> TCP and UDP packet headers and the data payload. It was originally developed
> for use as a P2P protocol identification mechanism, but has wound up being
> general enough for wider use.

That almost feels like doing floating-point in kernelspace.



Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
| jengelh's site, http://jengelh.hopto.org/
