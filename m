From: Deti Fliegl <deti@fliegl.de>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Sat, 26 Nov 2005 15:57:18 +0100
Message-ID: <438877CE.2050305@fliegl.de>
References: <43760B97.9010603@fliegl.de>
	<4380B5B1.9040506@trash.net>	<4384A904.4080700@fliegl.de>
	<4388730A.2060003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4388730A.2060003@trash.net>
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

Patrick McHardy wrote:
> I hate these unreadable x86_64 oopses. What commands do you use in your
> stresstest?
Well sorry for having a 64bit system. This is my stresstest script:

---- snip
#! /bin/bash
loop1()
{
         while true; do wget -qO /dev/null 
ftp://ftp.leo.org/pub/linux/kernel/v2.6/linux-2.6.13.tar.bz2; done
}

loop2()
{
         while true; do wget -qO /dev/null 
http://localhost/external.png; done
}

loop1 &
loop2 &
loop2 &

while true; do  date; conntrack -L|wc -l; done
--- snap

The Oops happens after 4-5 hours running the script above. For 
explaination:

- loop1 causes app. 850Mbit/s bandwidth
- loop2 causes app. 30000 connections on local webserver (file 
external.png has 672bytes)
- The conntrack-L loop crashes the box while loop1/2 are running.

Deti
