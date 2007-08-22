From: "Cedrix" <netfilter@cedrix.com>
Subject: Re: Re: conntrack: Connection close event?
Date: Thu, 23 Aug 2007 01:17:55 +0200
Message-ID: <001b01c7e512$ab8b65c0$1700a8c0@xcony13>
References: <004501c7e4e6$74509e80$1700a8c0@xcony13>
	<Pine.LNX.4.64.0708222103450.16690@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

>> In Short: I need to know when a connection (TCP or UDP) gets closed. I 
>> want
>> to use conntrack, because I can track UDP more easily.
>>
>> Any help or comment is appreciated! Thanks.

>Something like nfnetlink & "conntrack -E --event-mask NEW,DESTROY -o 
>timestamp"?:
>
>I'm not sure if it is possible just to grab udp events, if not you can
>filter it in an application.
>

That's perfect! Thanks Krzystof, Thanks Eric!

Cedrix. 
