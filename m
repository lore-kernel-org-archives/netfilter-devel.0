From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: Re: Condition for 2.6?
Date: Sat, 06 Nov 2004 12:15:10 -0500
Message-ID: <418D069E.1060309@videotron.ca>
References: <000101c4c3e7$53404880$450aa8c0@hierzo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: "mailto:netfilter-devel"@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <000101c4c3e7$53404880$450aa8c0@hierzo>
To: Udo van den Heuvel <udovdh@xs4all.nl>
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

Udo van den Heuvel wrote:
> Hello,
> 
> Will there be a netfilter/iptables 'condition' extension for kernel 2.6.x?
> 
> Kind regards,
> Udo
> 
> 
> 

Udo,

    I will port the condition module to 2.6 and send a notification to 
the list when I'm done. Unfortunately, I will be very busy up to 
december 14th as I'm working on my Master's degree.

    The issue with porting the code to 2.6 is known to me. I need to 
adapt the module so that it uses seq files and something else has 
changed in the proc interface from kernel 2.4 that crashes the kernel 
when writing to the proc file.

    I would be very happy if someone can point me the solution. I'll be 
able to release it much sooner.

    Up to now, I have received a number of emails regarding the 
condition module. I'm very happy to know that it has been, up to now, 
used successfully in many places and that it is rock-solid.

Regards,

Stephane Ouellette
