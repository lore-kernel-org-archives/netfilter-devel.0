From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Thu, 20 Apr 2006 20:51:37 +0200
Message-ID: <4447D839.804@trash.net>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
	<Pine.LNX.4.64.0604201844440.18935@mercury.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	pablo@netfilter.org, David Vogt <beunlovable@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven-Haegar Koch <haegar@sdinet.de>
In-Reply-To: <Pine.LNX.4.64.0604201844440.18935@mercury.sdinet.de>
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

Sven-Haegar Koch wrote:
>> + if test "$with_kernel" = ""; then
>> +   KERNEL="`uname -r`"
>> + else
>> +   KERNEL="$with_kernel"
>> + fi
> 
> 
> Shouldn't --with-kernel let me specify a kernel source directory,
> instead of a kernel version and then using some heuristicts to find the
> source directory? (The heuristic for the default using
> /lib/modules/`uname -r`/build is fine)

I agree, if someone sends me a patch to change it I'll apply it.
