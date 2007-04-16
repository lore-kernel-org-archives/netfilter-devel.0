From: Michael Guntsche <mike@it-loops.com>
Subject: Re: RTSP support for kernels >= 2.6.20
Date: Mon, 16 Apr 2007 15:15:31 +0200
Message-ID: <92EB4CD4-15DB-4C30-8EBD-774546F5B697@it-loops.com>
References: <39DCB6E6-58AA-4994-8530-16BB8FC85704@it-loops.com>
	<46228193.1040707@trash.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46228193.1040707@trash.net>
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


On Apr 15, 2007, at 21:48, Patrick McHardy wrote:

> If you want anyone to look at the patch you should attach it in a way
> that allows reading in the mail client, nobody is going to save and
> unpack it.

I am sorry, I just wanted to keep the size down.
I was able to make some progress today. Both modules compiled and I  
see that at least part of it is working.
One of the parts of the code I was not able to port is this.

exp->tuple = ((struct ip_conntrack_tuple)
        {
          { ct->tuplehash[!dir].tuple.src.ip,
            { 0 }
          },
          {
            ct->tuplehash[!dir].tuple.dst.ip,
            { .udp = { htons(expinfo.loport) } },
            IPPROTO_UDP
          }
        });
exp->mask = ((struct ip_conntrack_tuple)
        {
          { 0,
            { 0 }
          },
          {
            0xFFFFFFFF,
            { .udp = { 0xFFFF } }, 0xFF
          }
        });

I think I need to use a nf_conntrack_tuple instead but I was not able  
to figure out how.
Maybe someone can take a look at this and tell me what's missing for  
a nf_conntrack_tuple.


Kind regards,
Michael
