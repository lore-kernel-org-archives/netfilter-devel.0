From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: __signed__ ?
Date: Thu, 22 Apr 2004 10:50:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404220959200.1524-100000@filer.marasystems.com>
References: <40877B3B.5070808@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <40877B3B.5070808@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 22 Apr 2004, Ozgur AKAN wrote:

> I am working on netfilter source. I see that there are some definations like
> 
> typedef __unsigned__ int __s32;
> 
> 1- what does __signed__ mean? what is the difference from signed?

None.

> 2- I can not find the corrosponding code of ...ipv4/netfilter/ip_tables.c in cvs.netfilter.org. 
> Is in cvs.netfilter.org only userspace programs shown?

cvs.netfilter.org only has the userspace + files or modifications not yet
incorporated into the kernel.

The bulk of the netfilter/iptables kernel code is found in the normal 
kernel repositories and there is no need to have these duplicated in the 
netfilter cvs.

Regards
Henrik
