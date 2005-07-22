From: Patrick McHardy <kaber@trash.net>
Subject: Re: lockhelp.h missing
Date: Fri, 22 Jul 2005 07:56:10 +0200
Message-ID: <42E08A7A.6010204@trash.net>
References: <debc30fc050721223469bd79d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
In-Reply-To: <debc30fc050721223469bd79d6@mail.gmail.com>
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

Jérôme Poulin schrieb:
> I've got latest kernel 2.6.13-r1 with andrew morton patch mm1 and
> applied latest patch-o-matic-ng (2005-07-21 today) with ./runme extra
> which successfully applied.
> 
> When compiling the kernel I get some bad result (quoted some errors
> below) because of the lockhelp.h file missing in kernel builds greater
> or equal to 2.6.12.
> 
> This error repeats for each file including ip_conntrack_mms.h after
> removing lockhelp.h from the #include

lockhelp.h got killed, some patches in pomng still need to be updated.
I'll happily take patches ..

Regards
Patrick
