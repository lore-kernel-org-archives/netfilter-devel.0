From: Roberto Jung Drebes <drebes@inf.ufrgs.br>
Subject: Re: GFP_ATOMIC vs GFP_KERNEL in netfilter module
Date: Mon, 6 Dec 2004 11:10:21 -0200
Message-ID: <2EC8FF2C-4788-11D9-859D-000A957B2B6C@inf.ufrgs.br>
References: <92A26C52-44B7-11D9-A62F-000A957B2B6C@inf.ufrgs.br>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <92A26C52-44B7-11D9-A62F-000A957B2B6C@inf.ufrgs.br>
To: Roberto Jung Drebes <drebes@inf.ufrgs.br>
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


On 02/12/2004, at 21:12, Roberto Jung Drebes wrote:

> If I use GFP_ATOMIC, I don't get the error, but I think timers are not 
> being called after the delay. I have a similar code for transmition, 
> which works OK with GFP_KERNEL (delays messages) but with GFP_ATOMIC 
> it does also not delay.
>
> I test delay with ping, and I am running kernel 2.6.8-1.521 from 
> Fedora Core 2.
>
> What am I doing wrong?

Just for reference, everything was working alright with GFP_ATOMIC. I 
thought the timer was not installed because ping would not detect the 
delay. This happened because ping writes to the ICMP packet the 
timestamp when it is first received by the kernel, before netfilter 
hooks. Using ping with the old behavior (ping -U) worked as expected, 
printing the time the packet was kept in my netfilter hook.

Thanks,

-- 
Roberto Jung Drebes <drebes@inf.ufrgs.br>
Porto Alegre, RS - Brasil
http://www.inf.ufrgs.br/~drebes/
