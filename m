From: Michael Guntsche <mike@it-loops.com>
Subject: Re: RTSP support for kernels >= 2.6.20
Date: Mon, 16 Apr 2007 16:32:54 +0200
Message-ID: <2AFE2224-4F76-4199-9D41-F9AB48A57E9E@it-loops.com>
References: <39DCB6E6-58AA-4994-8530-16BB8FC85704@it-loops.com>
	<46228193.1040707@trash.net>
	<92EB4CD4-15DB-4C30-8EBD-774546F5B697@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <92EB4CD4-15DB-4C30-8EBD-774546F5B697@it-loops.com>
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


On Apr 16, 2007, at 15:15, Michael Guntsche wrote:

>
> I am sorry, I just wanted to keep the size down.
> I was able to make some progress today. Both modules compiled and I  
> see that at least part of it is working.
> One of the parts of the code I was not able to port is this.

Answering my own E-Mail. I found my problem with the struct for the  
tuple.

exp->tuple = ((struct nf_conntrack_tuple)
         {
           { ct->tuplehash[!dir].tuple.src.u3,
             { 0 },
           },
           {
             ct->tuplehash[!dir].tuple.dst.u3,
             { .udp = { htons(expinfo.loport) } },
             IPPROTO_UDP
           }
         });

This worked. I was not able to get the ->mask correctly though. For  
testing purposes I used this.


exp->mask = ((struct nf_conntrack_tuple)
         {
           { ct->tuplehash[!dir].tuple.src.u3,
             { 0 }
           },
           {
             ct->tuplehash[!dir].tuple.src.u3,
             { .udp = { 0xFFFF } }, 0xFF
           }
         });

and it worked with several test streams. I am pretty sure that this  
is completely wrong though and I would appreciate an< hints/tips on  
how to get this right.
If this is fixed I'll start cleaning everything up and send a patch  
to the list.


Kind regards,
Michael
