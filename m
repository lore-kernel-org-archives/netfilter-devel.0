From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: NAT for IPv6
Date: Thu, 20 Nov 2003 16:11:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBCCBA0.7020309@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

> On Wed, Nov 19, 2003 at 01:38:47PM +0100, Maciej Soltysiak wrote:
>  
>
>> Hello,
>>
>> out of curiousity - are there plans to incorporate NAT into ip6tables
>> or future pkttables ?
>>   
>
>
> over my dead body.  NAT is what broke ipv4 end-to-end.  Let's not do the
> same with ipv6.
>
> The only reasonable application is ipv4-to-ipv6 transition-nat.
>  
>

I wonder... Can every NAT applications be replaced by ipv6? Now, the 
application area of NAT is much bigger than the original goals (e.g. 
security applications, easing network administration), so I wonder if 
ipv6 can make NAT useless. Without proof of the contrary I would say 
that NAT will still be usefull.

              Emmanuel
