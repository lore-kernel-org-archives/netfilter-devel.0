From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: 2.6.20-rc4: known unfixed regressions
Date: Mon, 08 Jan 2007 02:20:02 +0100
Message-ID: <45A19C42.8080109@birkenwald.de>
References: <Pine.LNX.4.64.0701062216210.3661@woody.osdl.org>
	<20070108002208.GO20714@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
	netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070108002208.GO20714@stusta.de>
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

Adrian Bunk wrote:

> This email lists some known regressions in 2.6.20-rc4 compared to 2.6.19.

> Subject    : netfilter conntrack Oopses
> References : http://lkml.org/lkml/2007/1/4/156

Netfilter bugzilla #528
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=528

fixed, I think the patch is in -rc4 already (it is listed in the "Merge 
/pub/scm/linux/kernel/git/davem/net-2.6" on Jan. 4th in the git browser)

>              http://lkml.org/lkml/2007/1/7/188

Netfilter bugzilla #529
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=529

no patch available yet, remote DoS attack for 2.6.20-rc3, not excluded 
this has been the case since nf_conntrack_ipv6 was available (2.6.16 or 
so), UDPv6 fragments are rare in the wild and a large number of users 
could not use nf_conntrack_ipv6 up to now due to incompatibility with 
IPv4 NAT code.

Regards,
Bernhard
