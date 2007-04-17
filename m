From: Michael Guntsche <mike@it-loops.com>
Subject: Re: RTSP support for kernels >= 2.6.20
Date: Wed, 18 Apr 2007 00:25:23 +0200
Message-ID: <E1B3F7EA-E02F-4A66-B786-F406D229E032@it-loops.com>
References: <39DCB6E6-58AA-4994-8530-16BB8FC85704@it-loops.com>	<46228193.1040707@trash.net>	<92EB4CD4-15DB-4C30-8EBD-774546F5B697@it-loops.com>
	<2AFE2224-4F76-4199-9D41-F9AB48A57E9E@it-loops.com>
	<46238CB4.3050504@trash.net>
	<A2FA4AAE-8D76-4C0A-8583-876DB5DAA031@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <A2FA4AAE-8D76-4C0A-8583-876DB5DAA031@it-loops.com>
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


On Apr 16, 2007, at 17:53, Michael Guntsche wrote:

> Attached you will find the two files that I am currently working  
> on. I tried to use expect_init as you suggested but It does not  
> work. Everything seems to be working, the packets get parsed, but I  
> see no traffic coming through.
> I left the old code as comment, since it worked with it. Maybe you  
> can take a look at it and tell me what I did wrong.
>

Ok, it looks like I was not really paying attention to what I was  
doing here, of course nf_conntrack_expect_init() works if you use it  
correctly. I fixed it and I will provide a full patch soon.
My question is against what codebase should I create the patch,  
2.6.20 or the latest 2.6.21-pre version?


Kind regards,
Michael
