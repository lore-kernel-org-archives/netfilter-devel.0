From: "=?windows-1251?Q?noip?=" <noip@webhost66.com>
Subject: Re: kernel panic with connlimit and 2.6.16.* kernels
Date: Wed, 26 Apr 2006 17:05:35 +0000
Message-ID: <20060426170535.27587.qmail@webhost66.com>
Reply-To: =?windows-1251?Q?noip?= <noip@webhost66.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1251"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,

I've tried the patch. But the problem is still here.
I want to ask what patch for kernel 2.6.16.9 should i use to set the CONFIG_STACK_BACKTRACE_COLS setting to value 2. 

Thank You
Iavor

 
>  -------Original Message-------
>  From: Krzysztof Oledzki <olenf@ans.pl>
>  Subject: Re: kernel panic with connlimit and 2.6.16.* kernels
>  Sent: 25 Apr '06 18:25
>  
>  
>  
>  On Tue, 25 Apr 2006, noip wrote:
>  
>  > Hello,
>  >
>  > I've described my problem in the linux kernel list here:
>  > http://www.ussg.iu.edu/hypermail/linux/kernel/0604.2/1472.html
>  >
>  > There I've recieved a reply from Patrick McHardy:
>  > http://www.ussg.iu.edu/hypermail/linux/kernel/0604.2/1666.html
>  >
>  > I've used a patch for connlimit from this thread, because without the patch i can't apply the connlimit patch from the latest patch-o-matic-ng snapshot to any 2.6.16 kernel:
>  > http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3456
>  
>  What about this one: ftp://ftp.ans.pl/pub/patches/nf/connlimit.patch.gz
>  
>  I have two positive replays saying that it works.
>  
>  Best regards,
>  
>  Krzysztof Olêdzki
