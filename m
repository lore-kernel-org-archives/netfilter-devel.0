From: Patrick McHardy <kaber@trash.net>
Subject: Re: [kernel panic] iptables 1.2.7a + physdev patch
Date: Sat, 17 Sep 2005 21:33:24 +0200
Message-ID: <432C6F84.90600@trash.net>
References: <000001c5baa6$f4bf1c70$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 7bit
Cc: 'Netfilter Development Mailinglist' <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vincent <cs83152@csie.chu.edu.tw>
In-Reply-To: <000001c5baa6$f4bf1c70$aa0ba8c0@l7.com.tw>
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

Vincent wrote:
> Hello folks,
> 
> I have experiencend a kernel panic with iptables. Does anyone point any
> hints for me?
> Thanks in advance.
> 
> My Enviroment:
> Linux Kernel : 2.6.10
> Iptables: 1.2.7a
> 
> PS. I port the physdev patch from 1.2.9 back to 1.2.7a. Will this action
> cause kernel panic?

No, it shouldn't.

> Oops: 0000 [#1]
> SMP
> CPU:    0
> EIP:    0060:[<c025a966>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.10)
> EIP is at target+0x24d/0x2ce

Unfortunately half the iptables targets use this name, so its hard to
tell which one it is. If this crash is reproducable you can find out
which module the function belongs to by comparing EIP with the output
of cat /proc/modules.
