From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: Re: [PATCH]  dead code elimination in ip6_queue.c
Date: Sun, 16 Mar 2003 23:47:12 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E755350.4090807@videotron.ca>
References: <Pine.LNX.4.44.0303161154050.29463-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Morris <jmorris@intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

James Morris wrote:

>On Sat, 15 Mar 2003, Stephane Ouellette wrote:
>
>  
>
>>Folks,
>>
>>   the following patch removes dead code in ip6_queue.c
>>
>>    
>>
>
>Incorrect, see NLMSG_PUT().
>
>
>- James
>  
>

James,

   I'm sorry.  I didn't check the macros...

   Thank you for pointing my mistake.

Stephane
