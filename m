From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: Counter problem in a new nat target.
Date: Wed, 10 Dec 2003 14:52:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD7170C.2080404@netlab.hut.fi>
References: <Pine.LNX.4.44.0312101211500.9708-100000@filer.marasystems.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Jesse Peng
 <jesse@deansoft.com.tw>,
        KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



>I would really recommend you to extend conntrack with a custom field for 
>the purpose than to abuse the helper slots.
>
>  
>
I was a bit reluctant to do this since I don't think it won't be useful 
for any applications other than mine. I thought it was a waste.

Thanks again for your help,

        Emmanuel
