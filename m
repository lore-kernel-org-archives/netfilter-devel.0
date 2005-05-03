From: Amin Azez <azez@ufomechanic.net>
Subject: Re: wow, why does everything presume ethernet? Re: skb->mac.raw,
 when is does it point to ethhdr
Date: Tue, 03 May 2005 09:23:39 +0100
Message-ID: <4277350B.2080904@ufomechanic.net>
References: <d4r2n4$o39$1@sea.gmane.org>
	<Pine.LNX.4.61.0504290113360.26003@filer.marasystems.com>
	<427258BF.7080405@ufomechanic.net>
	<Pine.LNX.4.61.0505012244340.23014@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0505012244340.23014@filer.marasystems.com>
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

Henrik Nordstrom wrote:

> On Fri, 29 Apr 2005, Amin Azez wrote:
>
>> However, to get at a source mac address is still uncertain, maybe I 
>> need to dispatch to a different routine or different offsets based on 
>> input_dev->type ?
>
> You need to know each and every link layer you need to support.
> The link layer part of the packet isn't supposed to be accessed 
> outside of the link layer, so this isn't made easy.
>
>> Does anyone know without looking how "ifconfig" works out how to 
>> format the mac address?
>
> If I am not wrong it simply hexdumps it with : between the octets. 
> Length is known. But there may be special cases for some link layers.. 
> see the source to make be sure. iproute just hext dumps it with :.

Hmm. You can guess what's coming next. MAC addresses are important in 
many filtering or logging scenarios. We've already gone past the point 
where we should have been using some formal method to extract the link 
layer addresses from the link layer header. I'm suggesting we introduce 
such a method in a way that it can be trivially added to each link layer 
once the information is available and where it is obvious for a link 
layer where that information is not available.

1) My first idea is extra fields in the device structure net_device. 
There are so few instances of this structure allocated I think we can 
afford the usage.
These will indicate the offset within the raw link layer packet header 
of the source and dest mac addresses. Together with net_device->addr_len 
this makes it simple and inexpensive to extract mac addresses as 
required. A value of -1 would indicate that these values are not 
available for a given network device.
This would be unsuitable if the mac addresses do not have fixed length 
or do not sit at the same header offset each time.

2) The link-layer code would fill in two pointers to the mac addresses 
in similar manner to sk_buff->mac.raw . If the mac length is not fixed 
then two slots must also exist to hold the length of each mac address. 
It may be cheap for most transports to fill in these two pointers, but 
as a per-packet operation it should perhaps only be enabled if netfilter 
is activated in the kernel configuration?

3) The final idea which I hope we don't need is to provide a callback 
address in net_device that may be applied to an sk_buff to extract out 
the mac addresses. This moves all expense to the instants that the mac 
addresses are needed, but makes the operations more expensive.

My suggestion is to take the first idea and move to the second (and 
<sob> third) if required.

Because the net_device is available from the skb, the functionality can 
be encapsulated in a macro or inline function in such a way as to 
survive any rework of the implementation. Perhaps these 6 functions:
get_src_mac_address(skb);
get_src_mac_address_len(skb);
copy_src_mac_address(dst,skb);
get_dst_mac_address(skb);
get_dst_mac_address_len(skb);
copy_dst_mac_address(dst,skb);

Amin
