From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 15:13:09 +0200
Message-ID: <200608241513.10233.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<200608241258.58098.max@nucleus.it>
	<Pine.LNX.4.58.0608241310380.8098@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0608241310380.8098@blackhole.kfki.hu>
Content-Disposition: inline
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

On Thursday 24 August 2006 1:22 pm, Jozsef Kadlecsik wrote:

> I completely agree with your last sentence. But what I wanted to say is
> that when one issues such commands and then enters 'pkttables/nf --save'
> to get the actual ruleset from the kernel, one expects the exactly same
> rule returned, without missing parts. Even if the kernel cannot interpret
> and thus ignores some parts of the command at packet matching.

This is a broader consistency problem. With the current system iptables asks 
specifically for the match version that is supported by userspace. If a new 
(additional) version is implemented in the kernel, it won't be used.
If you change the userspace utility, it's up to the utility itself to 
support/convert the old save format.

A good userspace library framework will make this easier, but I think the 
current kernel version system is fine.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
