From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Q] problem(?) w/ owner_supgids patch
Date: Sat, 08 Nov 2003 14:07:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FACEA7D.7020104@trash.net>
References: <1068295928.18243.24.camel@lx.siec>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?Jaros=B3aw_Pyszny?= <arghil@tlen.pl>
In-Reply-To: <1068295928.18243.24.camel@lx.siec>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jaros³aw Pyszny wrote:

>Hi,
>I try build kernel from Fedora Core 1 (2.4.22-1.2115.nptl) with
>p-o-m(CVS).
>
>In ipt_owner.c (after patched) is call for_each_task macro, but this
>kernel haven't it. Any suggestion? 
>  
>

Redhat has a lot of 2.6 stuff in their kernels, for_each_task
became do_each_thread in 2.6. 

Best regards,
Patrick
