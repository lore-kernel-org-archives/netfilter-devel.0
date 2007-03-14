From: Amin Azez <azez@ufomechanic.net>
Subject: Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 12:43:03 +0000
Message-ID: <45F7EDD7.4070906@ufomechanic.net>
References: <et6fp4$l04$1@sea.gmane.org>	
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>	
	<45F6CD7C.40708@ufomechanic.net>	
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1173868532.26913.39.camel@henriknordstrom.net>
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

* Henrik Nordstrom wrote, On 14/03/07 10:35:
> tis 2007-03-13 klockan 17:18 +0100 skrev Jan Engelhardt:
>
>   
>> http://lkml.org/lkml/2006/8/22/26
>>
>> CONNMARK does in filter, MARK does not - I do not know what is
>> supposed to be going on.
>>     
>
> It's due to the relation of the per-packet nfmark being as a channel to
> return routing information from netfilter to the kernel. 
Thats exactly how I'm trying to use it, which is why I need to set it in
the nat table.

(I know that nat only applies to the first packet in a flow, I also use
CONNMARK later to save the mark combined with other data.)

> The
> per-connection conntrack mark used by CONNMARK does not have this
> property and does not need to be restricted in where it's modified.
>
> The restore operation of CONNMARK have the same restrictions as MARK as
> it too modifies the packet nfmark, and can therefore only be used from
> mangle just as MARK.
>   
Now this at least makes a little sense.

Sam
