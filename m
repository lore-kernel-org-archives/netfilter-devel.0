From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: Compilation error: nf_debug in nfnetlink.c
Date: Fri, 05 Dec 2003 19:21:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD0BE91.5000103@netlab.hut.fi>
References: <Pine.LNX.4.44.0312051801460.4633-100000@filer.marasystems.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

>> The error occurs in only three occurences of nf_debug(level, format, 
>> arg...) which do not have any arguments.
>>   
>
>
> What version of GCC are you using?
>
>  
>
It should be the 3.80 if I remember correctly.


          Emmanuel
