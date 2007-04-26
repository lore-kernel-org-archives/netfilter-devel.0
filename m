From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [patch] Fix for u32 patchlet and kernel 2.6.21
Date: Thu, 26 Apr 2007 20:40:52 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704262040350.506@yvahk01.tjqt.qr>
References: <200704261414.14643.thomas.jarosch@intra2net.com>
	<Pine.LNX.4.61.0704261652540.506@yvahk01.tjqt.qr>
	<200704261716.07261.thomas.jarosch@intra2net.com>
	<4630C3AD.3050904@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4630C3AD.3050904@trash.net>
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


On Apr 26 2007 17:22, Patrick McHardy wrote:
>Thomas Jarosch wrote:
>> On Thursday, 26. April 2007, Jan Engelhardt wrote:
>> 
>>>See http://lists.netfilter.org/pipermail/netfilter/2007-April/068389.html
>> 
>> 
>> Now I got it. You posted the patches to netfilter instead of netfilter-devel.
>> No wonder I have missed it on -devel :-)
>
>
>Same here, I don't read netfilter, so in case anything of them is
>relevant for netfilter SVN and you want me to apply them, please
>resend to netfilter-devel.

Is #ifdef kludgery for different kernel versions 'allowed' in pom?


Jan
-- 
