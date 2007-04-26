From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] Fix for u32 patchlet and kernel 2.6.21
Date: Fri, 27 Apr 2007 01:05:43 +0200
Message-ID: <46313047.4060703@trash.net>
References: <200704261414.14643.thomas.jarosch@intra2net.com>
	<Pine.LNX.4.61.0704261652540.506@yvahk01.tjqt.qr>
	<200704261716.07261.thomas.jarosch@intra2net.com>
	<4630C3AD.3050904@trash.net>
	<Pine.LNX.4.61.0704262040350.506@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704262040350.506@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Apr 26 2007 17:22, Patrick McHardy wrote:
> 
>>Same here, I don't read netfilter, so in case anything of them is
>>relevant for netfilter SVN and you want me to apply them, please
>>resend to netfilter-devel.
> 
> 
> Is #ifdef kludgery for different kernel versions 'allowed' in pom?


No, we decided to keep only versions for the latest kernel around.
You could add a include file that hides the version magic though,
I guess other people would be happy to have something like that
too.
